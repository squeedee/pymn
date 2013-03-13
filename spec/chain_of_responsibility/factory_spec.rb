require "spec_helper"
require "pymn/chain_of_responsibility/factory"

module Pymn
  module ChainOfResponsibility
    describe Factory do
      describe "dsl" do
        context "without a matching method" do
          subject do
            Class.new do
              include Pymn::ChainOfResponsibility::Factory
            end
          end

          it "fails to add the responsibility" do
            expect {
              subject.responsibility(:run_command) { true }
            }.to raise_error(Pymn::ChainOfResponsibility::ResponsibilityMethodUndefinedError)
          end
        end
      end


      describe "#add_handler" do
        let(:test_class) {
          Class.new do
            include Pymn::ChainOfResponsibility::Factory
            def self.build
              return new
            end

            responsibility(:build) { true }
          end
        }

        let(:next_handler) { double(:next_handler) }

        subject(:factory) { test_class.create_factory }

        it "provides a fluent interface for add_handler" do
          result = factory.add_handler(next_handler)
          result.should == factory
        end

        it "adds handlers to the leaf node" do
          factory.add_handler(next_handler)
          last_handler = double(:last_handler)
          next_handler.should_receive(:add_handler).with(last_handler)
          factory.add_handler(last_handler)
        end

      end

      describe "calling the handler" do
        let(:test_class) do
          Class.new do
            include Pymn::ChainOfResponsibility::Factory

            def self.build *args
              args
            end
          end
        end

        before do
          if can_handle 
            test_class.responsibility(:build) { true }
          else
            test_class.responsibility(:build) { false }
          end
        end

        subject(:build_handler) { test_class.create_factory }

        context "the factory handles the command" do
          let(:can_handle) { true }

          it "passes and return no args" do
            build_handler.build.should == []
          end

          it "passes and return any args" do
            build_handler.build(1,2,3).should == [1,2,3]
          end
        end

        context "the factory does not handle the command" do
          let(:can_handle) { false }

          context "singleton chain" do
            it "raises an exception" do
              expect { build_handler.build }.to raise_error(Pymn::ChainOfResponsibility::CommandNotHandledError)
            end
          end

          context "has another handler in chain" do
            let(:next_handler) { double(:next_handler) }

            before do
              build_handler.add_handler(next_handler)
            end

            it "calls the next handler" do
              next_handler.should_receive(:build).with([1,2,3])
              build_handler.build([1,2,3])
            end

          end
        end
      end

    end
  end
end
