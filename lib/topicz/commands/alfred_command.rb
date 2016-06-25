require_relative 'repository_command'
require 'json'

module Topicz::Commands

  class AlfredCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @identifiers = false
      @mode = :browse
      option_parser.order! arguments
      @filter = arguments.join ' '
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: alfred <filter>'
        options.on('-m', '--mode MODE', 'Set the output mode') do |mode|
          case mode.strip.downcase
            when 'browse' then
              @mode = :browse
              @identifiers = false
            when 'journal' then
              @mode = :journal
              @identifiers = true
            when 'note' then
              @mode = :note
              @identifiers = true
            else
              raise "Invalid mode: '#{mode}'"
          end
        end
        options.separator ''
        options.separator 'Searches for topics and produces the result in JSON for Alfred\'s Script Filter'
        options.separator ''
        options.separator 'The filter specifies the text to search on. The text is matched against the topic\'s: '
        options.separator '- path on the filesystem'
        options.separator '- id, if specified in the topic\'s topic.yaml file'
        options.separator '- title, if specified in the topic\'s topic.yaml file'
        options.separator '- aliases, if specified in the topic\'s topic.yaml file'
        options.separator ''
        options.separator 'Supported modes are:'
        options.separator '  browse  : For browsing through topics'
        options.separator '  journal : For creating journal entries'
        options.separator '  note    : For creating notes'
        options.separator ''
        options.separator 'Alfred automatically orders the items in its UI based on your usage.'
      end
    end

    def execute
      topics = @repository.find_all @filter
      items = []
      topics.each do |topic|
        item = {
            # https://www.alfredapp.com/help/workflows/inputs/script-filter/json/
            uid: topic.id, # Affects the ordering in Alfred, based on learning
            type: 'file',
            title: topic.title,
            subtitle: create_subtitle(topic),
            arg: @identifiers ? topic.id : topic.fullpath,
            icon: {
                type: 'fileicon',
                path: topic.fullpath
            }
        }
        if @mode == :browse
          item['mods'] = {
              cmd: {
                  subtitle: "Open topic '#{topic.title}' in Finder"
              },
              alt: {
                  subtitle: "Open topic '#{topic.title}' in editor"
              }
          }
        end
        items << item
      end
      puts ({items: items}.to_json)
    end

    def create_subtitle(topic)
      case @mode
        when :browse then
          "Browse topic '#{topic.title}' in Alfred Browser"
        when :journal then
          "Open this weeks journal entry for topic '#{topic.title}'"
        when :note then
          "Create a new note for topic '#{topic.title}'"
      end
    end

  end
end
