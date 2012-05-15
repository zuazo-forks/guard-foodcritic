require "guard"
require "guard/guard"

module Guard
  class Foodcritic < Guard
    def initialize(watchers=[], options={})
      super

      @options = {
        :all_on_start => true,
      }.merge(@options)
    end

    def start
      run_all if @options[:all_on_start]
    end
  end
end
