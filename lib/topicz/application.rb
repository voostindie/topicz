require 'topicz/version'
require 'topicz/command_factory'
require 'optparse'
require 'yaml'

module Topicz

  class Application

    attr_reader :command

    def initialize(arguments = ARGV, factory = CommandFactory.new)
      config_file = nil
      OptionParser.new do |options|
        options.banner = 'Usage: topicz [options] <command> [options]'
        options.program_name = 'topicz'
        options.version = Topicz::VERSION
        options.on('-c', '--config FILE', 'Uses FILE as the configuration file') do |file|
          config_file = file
        end
        options.separator ''
        options.separator 'Where <command> is one of: '
        options.separator ''
        options.separator Topicz::COMMANDS.to_s
      end.order! arguments

      unless arguments.empty?
        command = arguments.shift
        if Topicz::COMMANDS.has_key? command
          @command = factory.create_command(command, config_file, arguments)
        end
      end
    end

    def run
      if @command != nil
        @command.execute
      else
        raise 'Invalid command. Try topicz --help'
      end
    end

  end
end