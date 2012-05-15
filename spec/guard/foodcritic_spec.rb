require "spec_helper"
require "guard/foodcritic"

module Guard
  describe Foodcritic do
    it { should be_a_kind_of ::Guard::Guard }

    describe "#options" do
      it "[:all_on_start] defaults to true" do
        described_class.new.options[:all_on_start].should be_true
      end
    end

    describe "#start" do
      it "runs all on start if the :all_on_start option is set to true" do
        guard = described_class.new([], :all_on_start => true)
        guard.should_receive(:run_all)
        guard.start
      end

      it "does not run all on start if the :all_on_start option is set to false" do
        guard = described_class.new([], :all_on_start => false)
        guard.should_not_receive(:run_all)
        guard.start
      end
    end
  end
end
