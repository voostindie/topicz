require_relative 'repository_command'

module Topicz::Commands

  class StatsCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @week = Date.today.cweek
      @year = Date.today.cwyear
      option_parser.order! arguments
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: stats'
        options.on('-w', '--week WEEK', 'Use week WEEK instead of the current week') do |week|
          @week = week.to_i
        end
        options.on('-y', '--year YEAR', 'Use year YEAR instead of the current year') do |year|
          @year = year.to_i
        end
        options.separator ''
        options.separator 'Generates weekly statistics across all topics.'
        options.separator ''
        options.separator 'This command reports on all Documents, Notes and Reference Material across all topics.'
        options.separator 'Contrary to what you might think, this command does NOT look at file timestamps!'
        options.separator 'Instead it expects each filename to start with a date in yyyy-mm-dd format.'
      end
    end

    def execute
      date = Date.commercial(@year, @week)
      first = date.strftime('%Y-%m-%d')
      last = (date + 7).strftime('%Y-%m-%d')

      output = []
      @repository.topics.each do |topic|
        stats = find_files(topic, first, last)
        next if stats.empty?
        item = "#{topic.title}\n"
        stats.each {|path| item += "* #{path}\n"}
        output << item
      end

      puts output.join("\n") unless output.empty?
    end

    GLOB_PATTERN = File.join("{#{Topicz::DIR_NOTES},#{Topicz::DIR_DOCUMENTS},#{Topicz::DIR_REFERENCE}}", '*')

    def find_files(topic, first, last)
      Dir.chdir(topic.fullpath) do
        Dir.glob(GLOB_PATTERN).select do |path|
          file = File.basename(path)
          file >= first && file < last
        end.sort
      end
    end

  end
end
