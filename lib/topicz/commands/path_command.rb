require_relative 'repository_command'
require 'json'

module Topicz::Commands
  class PathCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @filter = arguments.join ' '
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: path <filter>'
        options.separator ''
        options.separator 'Prints the absolute path to the topic that matches <filter>.'
        options.separator ''
        options.separator 'The filter specifies the text to search on. The text is matched against the topic\'s: '
        options.separator '- path on the filesystem'
        options.separator '- title, if specified in the topic\'s topic.yaml file'
        options.separator '- aliases, if specified in the topic\'s topic.yaml file'
        options.separator ''
        options.separator 'The filter must return precisely one topic. Zero or more matches give an error.'
      end
    end

    def execute
      topics = @repository.find_all @filter
      if topics.length == 0
        raise "No topics found matching the search filter: '#{@filter}'"
      end
      if topics.length > 1
        matches = topics.map { |t| t.title }.join("\n")
        raise "Multiple topics match the search filter: '#{@filter}'. Matches:\n#{matches}"
      end
      print topics[0].fullpath
    end

  end
end
