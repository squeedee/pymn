require "spec_helper"
require "pymn/chain_of_responsibility/factory"

module Pymn
  module ChainOfResponsibility
    describe Factory do

      class TestClass
        include Factory

        def self.build
          return new
        end

        factory_responsibility(:build) { true }
      end

      subject { TestClass }

      its(:build) { should be_an_instance_of(TestClass) }

    end
  end
end
