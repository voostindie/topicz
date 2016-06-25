require_relative 'repository_command'
require 'json'

module Topicz::Commands

  class PathCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @strict = false
      option_parser.order! arguments
      @filter = arguments.join ' '
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: path <filter>'
        options.on('-s', '--strict', 'Do a full strict match on topic IDs only') do
          @strict = true
        end
        options.separator ''
        options.separator 'Prints the absolute path to the topic that matches <filter>.'
        options.separator ''
        options.separator 'The filter specifies the text to search on. The text is matched against the topic\'s: '
        options.separator '- path on the filesystem'
        options.separator '- id, if specified in the topic\'s topic.yaml file'
        options.separator '- title, if specified in the topic\'s topic.yaml file'
        options.separator '- aliases, if specified in the topic\'s topic.yaml file'
        options.separator ''
        options.separator 'The filter must return precisely one topic. Zero or more matches give an error.'
      end
    end

    def execute
      print find_exactly_one_topic(@filter, @strict).fullpath
    end

  end
end
