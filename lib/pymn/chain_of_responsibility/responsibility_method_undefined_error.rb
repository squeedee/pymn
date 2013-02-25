module Pymn
  module ChainOfResponsibility
    class ResponsibilityMethodUndefinedError < Exception
      def initialize method
        super("Responsibility must be called with an existing method. '#{method.to_s}' not defined.")
      end
    end
  end
end
