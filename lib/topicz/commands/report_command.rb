require_relative 'repository_command'
require 'json'

module Topicz::Commands

  class ReportCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @week = Date.today.cweek
      @year = Date.today.cwyear
      option_parser.order! arguments
      @filter = arguments.join ' '
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: report'
        options.on('-w', '--week WEEK', 'Use week WEEK instead of the current week') do |week|
          @week = week.to_i
        end
        options.on('-y', '--year YEAR', 'Use year YEAR instead of the current year') do |year|
          @year = year.to_i
        end
        options.separator ''
        options.separator 'Generates a weekly report from all journals across all topics.'
      end
    end

    def execute
      year = @year.to_s
      week = @week.to_s.rjust(2, '0')
      path = File.join(Topicz::DIR_JOURNAL, "#{year}-week-#{week}.md")

      @repository.topics.each do |topic|
        journal = File.join(topic.fullpath, path)
        next unless File.exist? journal

        puts "## #{topic.title}"
        puts
        puts File.readlines(journal)
                 .drop(2).join()          # Drop first 2 lines: title (week) and empty line
                 .gsub(/^#(.*)/, '##\1')  # Add an extra '#' in front of every title
                 .strip                   # Remove leading and ending whitespace
        puts
      end
    end

  end
end
