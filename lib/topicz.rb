require 'topicz/version'
require 'topicz/command_factory'
require 'optparse'

module Topicz

  def self.create_command(arguments = ARGV, factory = CommandFactory.new)

    subtext = <<HELP
Where command is one of:
   init       Initializes a new topic repository

See 'topicz <command> --help' for more information on a specific command.
HELP

    if arguments.empty?
      arguments = ["-h"]
    end

    global = OptionParser.new do |options|
      options.banner = 'Usage: topicz [options] <command> [options]'
      options.program_name = 'topicz'
      options.version = Topicz::VERSION
      options.on("-h", "--help", "Prints this help") do
        return factory.create('help', options)
      end
      options.separator ''
      options.separator subtext
    end.parse!(arguments)

    subcommands = {
        'init' => OptionParser.new do |opts|
          opts.banner = 'Usage: init'
        end
    }

    unless arguments.empty?
      command = arguments.shift
      if subcommands.include? command
        return factory.create(command, subcommands[command].parse(arguments))
      end
    end
  end
end
