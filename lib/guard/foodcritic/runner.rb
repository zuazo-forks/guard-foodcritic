require "guard/foodcritic"

module Guard
  class Foodcritic
    class Runner
      attr_reader :options

      def initialize(options={})
        @options = options
      end

      def run(paths)
        system command(paths)
      end
    end
  end
end
