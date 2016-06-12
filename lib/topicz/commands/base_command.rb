module Topicz::Commands
  class BaseCommand

    def initialize(arguments = [])
      @arguments = arguments
      @initialized = false
    end

    def execute
      unless @initialized
        init
        @initialized = true
      end
      run
    end

    def option_parser
      raise 'Not yet implemented!'
    end

    def init
      raise 'Not yet implemented!'
    end

    def run
      raise 'Not yet implemented!'
    end
  end
end
