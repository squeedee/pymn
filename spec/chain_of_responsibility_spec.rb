require "spec_helper"
require "pymn/chain_of_responsibility"

module Pymn
  describe ChainOfResponsibility do
    describe "dsl" do
      context "without a matching method" do
        subject do
          Class.new do
            include Pymn::ChainOfResponsibility
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
          include Pymn::ChainOfResponsibility
          def action
          end

          responsibility(:action) { true}
        end
      }

      let(:next_handler) { double(:next_handler) }
      subject(:instance) { test_class.new }

      it "provides a fluent interface for add_handler" do
        result = instance.add_handler(next_handler)
        result.should == instance
      end

      it "adds handlers to the leaf node" do
        instance.add_handler(next_handler)
        last_handler = double(:last_handler)
        next_handler.should_receive(:add_handler).with(last_handler)
        instance.add_handler(last_handler)
      end
    end

    describe "calling the handler" do
      let(:test_class) do
        Class.new do
          include Pymn::ChainOfResponsibility

          def run_command *args
            args
          end

        end
      end

      before do
        if can_handle 
          test_class.responsibility(:run_command) { true }
        else
          test_class.responsibility(:run_command) { false }
        end
      end

      subject(:command_handler) { test_class.new }

      context "the class handles the command" do
        let(:can_handle) { true }

        it "passes and return no args" do
          command_handler.run_command.should == []
        end

        it "passes and return any args" do
          command_handler.run_command(1,2,3).should == [1,2,3]
        end
      end

      context "the class does not handle the command" do
        let(:can_handle) { false }

        context "singleton chain" do
          it "raises an exception" do
            expect { command_handler.run_command }.to raise_error(Pymn::ChainOfResponsibility::CommandNotHandledError)
          end
        end

        context "has another handler in chain" do
          let(:next_handler) { double(:next_handler) }

          before do
            command_handler.add_handler(next_handler)
          end

          it "calls the next handler" do
            next_handler.should_receive(:run_command).with([1,2,3])
            command_handler.run_command([1,2,3])
          end

        end
      end
    end
  end
end
