require 'topicz/defaults'
require 'fileutils'
require 'optparse'
require 'yaml'

module Topicz::Commands

  class InitCommand

    def initialize(config_file = nil, arguments = [])
      @config_file = Topicz::DEFAULT_CONFIG_LOCATION
      option_parser.order! arguments
      unless arguments.empty?
        @directory = arguments.shift
      end
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: init [options] <directory>'
        options.on('-c', '--config FILE') do |file|
          @config_file = file
        end
        options.separator ''
        options.separator 'Initializes a new topic repository. This creates a directory and writes its
location into a configuration file.'
        options.separator ''
        options.separator 'If the directory already exists, this command fails.'
        options.separator ''
        options.separator 'If a configuration file already exists, it will not be overwritten.'
      end
    end

    def execute
      unless @directory
        raise 'Pass the location of the new repository as an argument.'
      end
      if File.exist? @directory
        raise "A file or directory already exists at this location: #{@directory}."
      end
      create_repository
      create_configuration
    end

    def create_repository
      FileUtils.mkdir_p(@directory)
      puts "New topic repository created at: #{@directory}."
    end

    def create_configuration
      if File.exist? @config_file
        puts "Skipping creation of configuration file; one already exists at #{@config_file}."
      else
        File.open(@config_file, 'w') do |file|
          file.write(YAML.dump({'repository' => @directory}))
        end
        puts "Configuration file saved to: #{@config_file}."
      end
    end
  end
end
