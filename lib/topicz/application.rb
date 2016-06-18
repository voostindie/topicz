require 'topicz/version'
require 'topicz/defaults'
require 'topicz/command_factory'
require 'optparse'
require 'yaml'

module Topicz

  class Application

    attr_accessor :config_file
    attr_reader :command

    def initialize(arguments = ARGV, factory = CommandFactory.new)

      OptionParser.new do |options|
        options.banner = 'Usage: topicz [options] <command> [options]'
        options.program_name = 'topicz'
        options.version = Topicz::VERSION
        options.on('-c', '--config FILE', 'Uses FILE as the configuration file') do |file|
          @config_file = file
        end
        options.separator ''
        options.separator 'Where <command> is one of: '
        options.separator ''
        options.separator Topicz::COMMANDS.to_s
      end.order! arguments

      unless arguments.empty?
        command = arguments.shift
        if Topicz::COMMANDS.has_key? command
          @command = factory.create_command(command, arguments)
        end
      end
    end

    def run
      if @command != nil
        if @command.requires_config?
          @command.execute load_config
        else
          @command.execute
        end
      else
        raise 'Invalid command. Try topicz --help'
      end
    end

    def load_config
      file = @config_file != nil ? @config_file : Topicz::DEFAULT_CONFIG_LOCATION
      unless File.exist? file
        raise "File doesn't exist: #{file}."
      end
      unless File.readable? file
        raise "File cannot be read: #{file}. Check permissions."
      end
      begin
        config = YAML.load_file(file)
      rescue
        raise "Not a valid YAML file: #{file}."
      end
      unless config.has_key?('repository')
        raise "Missing required property 'repository' in configuration file: #{file}."
      end
      repository = config['repository']
      unless Dir.exist? repository
        raise "Repository directory doesn't exist: #{repository}."
      end
      config
    end
  end
end