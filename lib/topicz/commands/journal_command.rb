require_relative 'editor_command'
require 'topicz/defaults'
require 'json'
require 'fileutils'

module Topicz::Commands

  class JournalCommand < EditorCommand

    def initialize(config_file = nil, arguments = [], kernel = Kernel)
      super(config_file)
      @kernel = kernel
      @strict = false
      @week = Date.today.cweek
      @year = Date.today.cwyear
      option_parser.order! arguments
      @filter = arguments.join ' '
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: journal <filter>'
        options.on('-s', '--strict', 'Do a full strict match on topic IDs only') do
          @strict = true
        end
        options.on('-w', '--week WEEK', 'Use week WEEK instead of the current week') do |week|
          @week = week.to_i
        end
        options.on('-y', '--year YEAR', 'Use year YEAR instead of the current year') do |year|
          @year = year.to_i
        end
        options.separator ''
        options.separator 'Opens the weekly journal for the specified topic.'
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
      topic = find_exactly_one_topic(@filter, @strict)
      path = File.join(topic.fullpath, Topicz::DIR_JOURNAL)
      FileUtils.mkdir(path) unless Dir.exist? path

      year = @year.to_s
      week = @week.to_s.rjust(2, '0')
      path = File.join(path, "#{year}-week-#{week}.md")

      unless File.exists? path
        File.open(path, 'w') do |file|
          file.puts("# #{topic.title} - Week #{week}, #{year}")
        end
      end

      @kernel.exec "#{editor} \"#{path}\""
    end

  end
end
