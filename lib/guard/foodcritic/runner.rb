require "guard/foodcritic"

module Guard
  class Foodcritic
    class Runner
      attr_reader :options

      def initialize(options)
        @options = options
      end
    end
  end
end
