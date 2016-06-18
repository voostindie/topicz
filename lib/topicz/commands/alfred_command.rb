require_relative 'repository_command'

module Topicz::Commands
  class AlfredCommand < RepositoryCommand

    def initialize(config_file, arguments = [])
      super(config_file)
      @arguments = arguments
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: alfred <filter>'
        options.separator ''
        options.separator 'Searches for topics and produces the result in JSON for Alfred\'s Script Filter'
      end
    end

    def execute

    end

  end
end
