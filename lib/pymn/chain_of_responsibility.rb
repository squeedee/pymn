require 'active_support/concern'
require 'pymn/chain_of_responsibility/command_not_handled_error'
require 'pymn/chain_of_responsibility/responsibility_method_undefined_error'

module Pymn
  module ChainOfResponsibility
    extend ActiveSupport::Concern

    module ClassMethods

      def responsibility method, &block
        unless method_defined?(method)
          raise ResponsibilityMethodUndefinedError.new(method)
        end

        command_method = "__command_#{method}".to_sym
        alias_method command_method, method

        define_method(method) do |*args|
          if instance_eval(&block) 
            return send(command_method, *args)
          end

          if @next_handler_in_chain
            return @next_handler_in_chain.send(method, *args)
          end

          raise CommandNotHandledError.new(method)
        end

      end

    end

    def add_handler(next_handler)
      @next_handler_in_chain = next_handler
    end


  end
end
