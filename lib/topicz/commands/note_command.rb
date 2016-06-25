require_relative 'editor_command'
require 'topicz/defaults'
require 'json'
require 'fileutils'
require 'zaru'

module Topicz::Commands

  class NoteCommand < EditorCommand

    def initialize(config_file = nil, arguments = [], kernel = Kernel)
      super(config_file)
      @kernel = kernel
      @strict = false
      option_parser.order! arguments
      @filter = arguments.shift
      @title = arguments.empty? ? nil : arguments.join(' ')
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: note <filter> [<title>]'
        options.on('-s', '--strict', 'Do a full strict match on topic IDs only') do
          @strict = true
        end
        options.separator ''
        options.separator 'Creates a new note for the specified topic.'
        options.separator ''
        options.separator 'The filter specifies the text to search on. The text is matched against the topic\'s: '
        options.separator '- path on the filesystem'
        options.separator '- id, if specified in the topic\'s topic.yaml file'
        options.separator '- title, if specified in the topic\'s topic.yaml file'
        options.separator '- aliases, if specified in the topic\'s topic.yaml file'
        options.separator ''
        options.separator 'The filter must return precisely one topic. Zero or more matches give an error.'
        options.separator ''
        options.separator 'The note title is optional. If omitted the title will be \'Unnamed note\'.'
      end
    end

    def execute
      topic = find_exactly_one_topic(@filter, @strict)
      path = File.join(topic.fullpath, Topicz::DIR_NOTES)
      FileUtils.mkdir(path) unless Dir.exist? path

      if @title
        date = DateTime.now.strftime('%Y-%m-%d')
        title = @title
        filename = Zaru.sanitize! "#{date} #{title}.md"
      else
        date = DateTime.now.strftime('%Y-%m-%d %H%M')
        title = 'Unnamed note'
        filename = "#{date}.md"
      end

      path = File.join(path, filename)

      unless File.exists? path
        File.open(path, 'w') do | file |
          file.puts("# #{topic.title} - #{title}")
        end
      end

      @kernel.exec "#{editor} \"#{path}\""
    end

  end
end
