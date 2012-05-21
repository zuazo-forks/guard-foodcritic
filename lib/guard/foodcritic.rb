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
        :notification => true,
      }.merge(@options)
    end

    def runner
      @runner ||= Runner.new(@options)
    end

    def start
      run_all if @options[:all_on_start]
    end

    def run_all
      UI.info "Linting all cookbooks"
      run! @options[:cookbook_paths]
    end

    def run_on_additions(paths)
      run_paths paths
    end

    def run_on_change(paths)
      run_paths paths
    end

    def run_on_modifications(paths)
      run_paths paths
    end

    def respond_to?(method_name, include_private=false)
      if %w(run_on_deletion run_on_change).include? method_name.to_s
        false
      else
        super
      end
    end

    private

    def run_paths(paths)
      UI.info "Linting: #{paths.join(' ')}"
      run! paths
    end

    def run!(paths)
      if runner.run(paths)
        Notifier.notify "Foodcritic passed", :image => :success if @options[:notification]
      else
        Notifier.notify "Foodcritic failed", :image => :failed if @options[:notification]
        throw :task_has_failed
      end
    end
  end
end
