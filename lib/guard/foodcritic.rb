require "guard"
require "guard/guard"

module Guard
  class Foodcritic < Guard
    autoload :Runner, "guard/foodcritic/runner"

    def initialize(watchers=[], options={})
      super

      @options = {
        :all_on_start => true,
        :cookbook_paths => ["cookbooks"],
      }.merge(@options)
    end

    def runner
      @runner ||= Runner.new(@options)
    end

    def start
      run_all if @options[:all_on_start]
    end

    def run_all
      runner.run @options[:cookbook_paths]
    end

    def run_on_change(paths)
      runner.run paths
    end
  end
end
