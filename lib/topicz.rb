require 'topicz/version'
require 'topicz/command_factory'
require 'optparse'

module Topicz

  def self.create_command(arguments = ARGV, factory = CommandFactory.new)

    commands = {
        'init' => 'Initializes a new topic repository',
        'help' => 'Shows help about a command',
    }

    config = nil

    global = OptionParser.new do |options|
      options.banner = 'Usage: topicz [options] <command> [options]'
      options.program_name = 'topicz'
      options.version = Topicz::VERSION
      options.on('-c', '--config FILE', 'Uses FILE as the configuration file, overriding ~/.topiczrc') do |file|
        unless File.exist? file
          raise "File #{file} doesn't exist"
        end
        config = file
      end
      options.separator ''
      options.separator 'Where <command> is one of: '
      options.separator ''
      commands.each_pair { |command, description| options.separator "     #{command.ljust(8)}: #{description}" }
    end.parse! arguments

    unless arguments.empty?
      command = arguments.shift
      if commands.has_key? command
        return factory.create(command, config, arguments)
      end
    end
  end
end
