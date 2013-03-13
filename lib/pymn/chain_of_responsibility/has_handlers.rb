module Pymn
  module ChainOfResponsibility
    module HasHandlers
      def add_handler(next_handler)
        if (@next_handler_in_chain)
          @next_handler_in_chain.add_handler(next_handler)
        else
          @next_handler_in_chain = next_handler
        end
        self
      end
    end
  end
end
