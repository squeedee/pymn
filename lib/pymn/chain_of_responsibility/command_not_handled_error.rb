module Pymn
  module ChainOfResponsibility
    class CommandNotHandledError < Exception
      def initialize(method)
        super("'#{method}' could not be handled")
      end
    end
  end
end
