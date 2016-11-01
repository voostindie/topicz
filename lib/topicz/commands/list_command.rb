require_relative 'repository_command'

module Topicz::Commands

  class ListCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @filter = arguments.join ' '
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: list [<filter>]'
        options.separator ''
        options.separator 'Lists topics'
        options.separator ''
        options.separator 'The filter specifies the text to search on. The text is matched against the topic\'s: '
        options.separator '- path on the filesystem'
        options.separator '- id, if specified in the topic\'s topic.yaml file'
        options.separator '- title, if specified in the topic\'s topic.yaml file'
        options.separator '- aliases, if specified in the topic\'s topic.yaml file'
      end
    end

    def execute
      @repository.find_all(@filter).each { |topic| puts topic.title }
    end

  end
end
