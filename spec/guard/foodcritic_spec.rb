require "spec_helper"
require "guard/foodcritic"

module Guard
  describe Foodcritic do
    before { Notifier.stub(:notify) }

    it { should be_a_kind_of ::Guard::Guard }

    describe "#options" do
      it "[:all_on_start] defaults to true" do
        described_class.new.options[:all_on_start].should be_true
      end

      it "[:cookbook_paths] defaults to ['cookbooks']" do
        described_class.new.options[:cookbook_paths].should == ["cookbooks"]
      end

      it "[:notification] defaults to true" do
        described_class.new.options[:notification].should be_true
      end
    end

    shared_examples "handles runner results" do
      context "the runner fails" do
        before { runner.stub(:run).and_return(false) }
        it { expect { subject }.to throw_symbol :task_has_failed }

        context "notifications are enabled" do
          let(:notification) { true }

          it "notifies the user of the failure" do
            Notifier.should_receive(:notify).with("Foodcritic failed", :image => :failed)
            catch(:task_has_failed) { subject }
          end
        end

        context "notifications are disabled" do
          let(:notification) { false }

          it "does not notify the user of the failure" do
            Notifier.should_not_receive(:notify)
            catch(:task_has_failed) { subject }
          end
        end
      end

      context "the runner succeeds" do
        before { runner.stub(:run).and_return(true) }
        it { expect { subject }.not_to throw_symbol :task_has_failed }

        context "notifications are enabled" do
          let(:notification) { true }

          it "notifies the user of the success" do
            Notifier.should_receive(:notify).with("Foodcritic passed", :image => :success)
            subject
          end
        end

        context "notifications are disabled" do
          let(:notification) { false }

          it "does not notify the user of the success" do
            Notifier.should_not_receive(:notify)
            subject
          end
        end
      end
    end

    describe "#run_all" do
      subject { guard.run_all }
      let(:guard) { described_class.new [], :cookbook_paths => %w(cookbooks site-cookbooks), :notification => notification }
      let(:notification) { false }
      let(:runner) { mock "runner", :run => true }
      before { guard.stub(:runner).and_return(runner) }

      it "runs the runner with the cookbook paths" do
        runner.should_receive(:run).with(guard.options[:cookbook_paths]).and_return(true)
        subject
      end

      it "informs the user" do
        UI.should_receive(:info).with("Linting all cookbooks")
        subject
      end

      include_examples "handles runner results"
    end

    describe "#run_on_change" do
      subject { guard.run_on_change(paths) }
      let(:guard) { described_class.new([], :notification => notification) }
      let(:notification) { false }
      let(:paths) { %w(recipes/default.rb attributes/default.rb) }
      let(:runner) { mock "runner", :run => true }
      before { guard.stub(:runner).and_return(runner) }

      it "runs the runner with the changed paths" do
        runner.should_receive(:run).with(paths).and_return(true)
        subject
      end

      it "informs the user" do
        UI.should_receive(:info).with("Linting: recipes/default.rb attributes/default.rb")
        subject
      end

      include_examples "handles runner results"
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
