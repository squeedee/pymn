require 'pymn/chain_of_responsibility'
require 'pymn/chain_of_responsibility/command_not_handled_error'
require 'pymn/chain_of_responsibility/responsibility_method_undefined_error'
require 'pymn/chain_of_responsibility/has_handlers'

module Pymn
  module ChainOfResponsibility
    module Factory
      extend ActiveSupport::Concern

      module ClassMethods
        def responsibility class_method, &block
          singleton_class = class << self; self; end

          unless singleton_class.method_defined?(class_method)
            raise ResponsibilityMethodUndefinedError.new(class_method)
          end

          singleton_class.instance_eval do
            define_method(:create_factory) do
              FactoryCommand.new(self, class_method, block) 
            end
          end
        end
      end

      class FactoryCommand
        include HasHandlers

        def initialize(target, factory_method, can_handle_block)
          create_method(factory_method)
          @factory_method = factory_method
          @target = target
          @can_handle_block = can_handle_block
        end

        private

        def call_target(*args)
          @target.send(@factory_method, *args)
        end

        def create_method(factory_method)
          singleton_class = class << self; self; end
          singleton_class.define_method(factory_method) do |*args|
            if @target.instance_exec(*args, &@can_handle_block)
              return call_target(*args)
            end

            if @next_handler_in_chain
              return @next_handler_in_chain.send(factory_method, *args)
            end

            raise CommandNotHandledError.new(@factory_method)
          end
        end
      end
    end


  end
end

