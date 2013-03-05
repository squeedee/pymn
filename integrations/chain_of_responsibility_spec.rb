require 'spec_helper'
require 'fixtures/chain_of_responsibility'

describe "Chain Of Responsibility" do
  let(:logger) { InfoLogger.new(buffer) }
  let(:error_logger) { ErrorLogger.new(buffer) }
  let(:warn_logger) { WarnLogger.new(buffer) }

  let(:buffer) { double(:buffer) }

  before do
    logger.add_handler(error_logger)
    logger.add_handler(warn_logger)
  end

  it "logs info prepended with 'Info:'" do
    buffer.should_receive(:<<).with("Info: you look nice today")
    logger.log(:info, "you look nice today")
  end

  it "logs warnings prepended with 'Warning:'" do
    buffer.should_receive(:<<).with("Warning: things look grim")
    logger.log(:warn, "things look grim")
  end

  it "logs errors in all caps" do
    buffer.should_receive(:<<).with("ERROR: OH NO, IT WENT WRONG")
    logger.log(:error, "oh no, it went wrong")
  end
end
