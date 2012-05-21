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
      let(:guard) { described_class.new [], :cookbook_paths => %w(cookbooks site-cookbooks) }
      let(:runner) { mock "runner" }
      before { guard.stub(:runner).and_return(runner) }

      it "runs the runner with the cookbook paths" do
        runner.should_receive(:run).with(guard.options[:cookbook_paths]).and_return(true)
        guard.run_all
      end

      it "throws :task_has_failed if runner returns false" do
        runner.stub(:run).and_return(false)
        expect { guard.run_all }.to throw_symbol :task_has_failed
      end

      it "does not throw :task_has_failed if the runner returns true" do
        runner.stub(:run).and_return(true)
        expect { guard.run_all }.not_to throw_symbol :task_has_failed
      end
    end

    describe "#run_on_change" do
      let(:guard) { described_class.new }
      let(:runner) { mock "runner" }
      before { guard.stub(:runner).and_return(runner) }

      it "runs the runner with the changed paths" do
        paths = %w(recipes/default.rb attributes/default.rb)
        runner.should_receive(:run).with(paths).and_return(true)
        guard.run_on_change(paths)
      end

      it "throws :task_has_failed if runner returns false" do
        runner.stub(:run).and_return(false)
        expect { guard.run_on_change([]) }.to throw_symbol :task_has_failed
      end

      it "does not throw :task_has_failed if the runner returns true" do
        runner.stub(:run).and_return(true)
        expect { guard.run_on_change([]) }.not_to throw_symbol :task_has_failed
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
        runner.options.should include guard.options
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
