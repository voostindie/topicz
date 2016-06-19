require_relative 'repository_command'
require 'json'

module Topicz::Commands
  class AlfredCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @filter = arguments.join ' '
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: alfred <filter>'
        options.separator ''
        options.separator 'Searches for topics and produces the result in JSON for Alfred\'s Script Filter'
        options.separator ''
        options.separator 'The filter specifies the text to search on. The text is matched against the topic\'s: '
        options.separator '- path on the filesystem'
        options.separator '- title, if specified in the topic\'s topic.yaml file'
        options.separator '- aliases, if specified in the topic\'s topic.yaml file'
        options.separator ''
        options.separator 'Alfred automatically orders the items in its UI based on your usage.'
      end
    end

    def execute
      topics = @repository.find_all @filter
      items = []
      topics.each do |topic|
        items << {
            uid: topic.fullpath, # Affects the ordering in Alfred, based on learning
            type: 'file',
            title: topic.title,
            subtitle: 'Browse topic in Alfred Browser',
            arg: topic.fullpath,
            mods: {
                cmd: {
                    subtitle: 'Open topic in Finder'
                },
                alt: {
                    subtitle: 'Open topic in editor'
                }
            },
            icon: {
                type: 'fileicon',
                path: topic.fullpath
            }
        }
      end
      puts ({items: items}.to_json)
    end

  end
end
