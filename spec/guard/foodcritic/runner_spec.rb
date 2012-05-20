require "spec_helper"
require "guard/foodcritic/runner"

module Guard
  describe Foodcritic::Runner do
    describe "#options" do
      it "remembers the initialized options" do
        options = { :foo => "bar" }
        described_class.new(options).options.should == options
      end
    end
  end
end
