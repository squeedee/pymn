require 'pymn/chain_of_responsibility'

class ErrorLogger
  include Pymn::ChainOfResponsibility

  def initialize(buffer)
    @buffer = buffer
  end

  def log(type, message)
    @buffer << "ERROR: #{message.upcase}"
  end

  responsibility(:log) { |type, message| type == :error }
end

class WarnLogger
  include Pymn::ChainOfResponsibility

  def initialize(buffer)
    @buffer = buffer
  end

  def log(type, message)
    @buffer << "Warning: #{message}"
  end

  responsibility(:log) { |type, message| type == :warn }
end

class InfoLogger
  include Pymn::ChainOfResponsibility

  def initialize(buffer)
    @buffer = buffer
  end

  def log(type, message)
    @buffer << "Info: #{message}"
  end

  responsibility(:log) { |type, message| type == :info }
end
