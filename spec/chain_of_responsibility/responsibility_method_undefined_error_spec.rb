require 'spec_helper'
require 'pymn/chain_of_responsibility'

module Pymn
  module ChainOfResponsibility
    describe ResponsibilityMethodUndefinedError do
      subject { ResponsibilityMethodUndefinedError.new(:my_method) }

      its(:message) { should include "'my_method' not defined" }
    end
  end
end
