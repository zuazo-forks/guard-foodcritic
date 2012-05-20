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
      run! @options[:cookbook_paths]
    end

    def run_on_change(paths)
      run! paths
    end

    private

    def run!(paths)
      runner.run(paths) or throw :task_has_failed
    end
  end
end
