require "spec_helper"
require "guard/foodcritic/runner"

module Guard
  describe Foodcritic::Runner do
    describe "#options" do
      it "remembers the initialized options" do
        options = { :foo => "bar" }
        described_class.new(options).options.should include options
      end

      it "[:cli] defaults to '--epic-fail any'" do
        described_class.new.options[:cli].should == "--epic-fail any"
      end
    end

    describe "#command" do
      let(:runner) { described_class.new }
      let(:paths) { %w(recipes/default.rb attributes/default.rb) }
      subject { runner.command(paths) }

      it "calls the foodcritic executable" do
        should start_with "foodcritic"
      end

      it "passes the given paths to the foodcritic executable" do
        should end_with paths.join(" ")
      end

      it "includes the cli option" do
        should include runner.options[:cli]
      end
    end

    describe "#run" do
      let(:runner) { described_class.new }
      let(:command) { mock "command" }
      before { runner.stub(:command).and_return(command) }

      it "generates the command with the given paths and runs it" do
        paths = %w(recipes/default.rb attributes/default.rb)
        runner.should_receive(:system).with(command)
        runner.run(paths)
      end

      it "returns true when foodcritic suceeds" do
        runner.stub(:system).and_return(true)
        runner.run([]).should be_true
      end

      it "returns false when foodcritic finds fault" do
        runner.stub(:system).and_return(false)
        runner.run([]).should be_false
      end
    end
  end
end
