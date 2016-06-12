require 'topicz/version'
require 'topicz/command_factory'
require 'optparse'
require 'yaml'

module Topicz

  @config_file = nil

  def self.config_file
    @config_file
  end

  def self.config_file= (file)
    @config_file = file
  end

  def self.create_command(arguments = ARGV, factory = CommandFactory.new)

    OptionParser.new do |options|
      options.banner = 'Usage: topicz [options] <command> [options]'
      options.program_name = 'topicz'
      options.version = Topicz::VERSION
      options.on('-c', '--config FILE', 'Uses FILE as the configuration file, overriding ~/.topiczrc') do |file|
        @config_file = file
      end
      options.separator ''
      options.separator 'Where <command> is one of: '
      options.separator ''
      Topicz::COMMANDS.each_pair do |command, description|
        options.separator "     #{command.ljust(8)}: #{description}"
      end
    end.parse! arguments

    unless arguments.empty?
      command = arguments.shift
      if Topicz::COMMANDS.has_key? command
        return factory.create_command(command, arguments)
      end
    end
  end

  def self.load_config
    file = @config_file != nil ? @config_file : File.join(Dir.home, '.topiczrc')
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
