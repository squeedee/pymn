require 'pymn/chain_of_responsibility'

class 
  include Pymn::ChainOfResponsibility

  def initialize(supports_type)
    @supports_type = supports_type
  end

  def handle_message message, type
    message
  end

  responsibility (:handle_message) { |message, type| type == @supports_type }

end
