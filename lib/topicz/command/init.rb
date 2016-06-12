require 'topicz/defaults'
require 'fileutils'
require 'optparse'
require 'yaml'

module Topicz::Command

  class Init

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: init [options] <directory>'
        options.on('-c', '--config FILE') do |file|
          @config_file = file
        end
        options.separator ''
        options.separator <<HELP
Initializes a new topic repository. This creates a directory and writes its
location into a configuration file.

If the directory already exists, this command fails.

If a configuration file already exists, it will not be overwritten.
HELP
      end
    end

    def prepare(arguments = [])
      @config_file = Topicz::DEFAULT_CONFIG_LOCATION
      option_parser.parse! arguments
      if arguments.empty?
        raise 'Pass the location of the new repository as an argument.'
      else
        @repository = arguments.shift
      end
      self
    end

    def requires_config?
      false
    end

    def execute
      if File.exist? @repository
        raise "A file or directory already exists at this location: #{@repository}."
      end
      create_repository
      create_configuration
    end

    def create_repository
      FileUtils.mkdir_p(@repository)
      puts "New topic repository created at: #{@repository}."
    end

    def create_configuration
      if File.exist? @config_file
        puts "Skipping creation of configuration file; one already exists at #{@config_file}."
        return false
      end
      File.open(@config_file, 'w') do |file|
        file.write(YAML.dump({'repository' => @repository}))
      end
      puts "Configuration file saved to: #{@config_file}."
      true
    end

    def help
      option_parser.to_s
    end

  end
end
