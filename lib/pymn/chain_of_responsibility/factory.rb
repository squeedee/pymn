require 'pymn/chain_of_responsibility'

module Pymn
  module ChainOfResponsibility
    module Factory
      extend ActiveSupport::Concern

      module ClassMethods
        def factory_responsibility(class_method, &block)
          singleton_class = class << self; self; end

          singleton_class.instance_eval do
            include Pymn::ChainOfResponsibility
            responsibility(class_method, &block)
          end
        end
      end
    end

  end
end

