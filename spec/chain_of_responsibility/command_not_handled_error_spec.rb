require 'spec_helper'
require 'pymn/chain_of_responsibility'

module Pymn
  module ChainOfResponsibility
    describe CommandNotHandledError do
      subject { CommandNotHandledError.new(:the_command) }

      its(:message) { should include "'the_command' could not be handled" }
    end
  end
end

