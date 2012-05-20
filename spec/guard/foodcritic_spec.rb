require "spec_helper"
require "guard/foodcritic"

module Guard
  describe Foodcritic do
    it { should be_a_kind_of ::Guard::Guard }

    describe "#options" do
      it "[:all_on_start] defaults to true" do
        described_class.new.options[:all_on_start].should be_true
      end

      it "[:cookbook_paths] defaults to ['cookbooks']" do
        described_class.new.options[:cookbook_paths].should == ["cookbooks"]
      end
    end

    describe "#run_all" do
      it "runs the runner with the cookbook paths" do
        guard = described_class.new([], :cookbook_paths => %w(cookbooks site-cookbooks))
        runner = mock("runner")
        guard.stub(:runner).and_return(runner)

        runner.should_receive(:run).with(guard.options[:cookbook_paths])
        guard.run_all
      end
    end

    describe "#run_on_change" do
      it "runs the runner with the changed paths" do
        guard = described_class.new
        runner = mock("runner")
        guard.stub(:runner).and_return(runner)
        paths = %w(recipes/default.rb attributes/default.rb)

        runner.should_receive(:run).with(paths)
        guard.run_on_change(paths)
      end
    end

    describe "#runner" do
      it "returns a Runner" do
        described_class.new.runner.should be_a_kind_of Foodcritic::Runner
      end

      it "memoizes the runner" do
        guard = described_class.new
        guard.runner.should equal guard.runner
      end

      it "configured the runner with the guard options" do
        guard = described_class.new
        runner = guard.runner
        runner.options.should == guard.options
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
