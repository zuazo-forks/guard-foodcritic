require "spec_helper"
require "guard/foodcritic"

module Guard
  describe Foodcritic do
    it { should be_a_kind_of ::Guard::Guard }
  end
end
