require "guard"
require "guard/guard"

module Guard
  class Foodcritic < Guard
    def initialize(watchers=[], options={})
      super

      @options = {
        :all_on_start => true,
        :cookbook_paths => ["cookbooks"],
      }.merge(@options)
    end

    def start
      run_all if @options[:all_on_start]
    end

    def run_all
      runner.run @options[:cookbook_paths]
    end
  end
end
