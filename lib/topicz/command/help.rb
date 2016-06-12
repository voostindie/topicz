require 'topicz/command_factory'

module Topicz::Command

  class Help

    def initialize(arguments = [])
      if arguments.empty?
        @command = nil
      else
        @command = arguments.shift
      end
    end

    def requires_config?
      false
    end

    def execute
      puts @command == nil ? Help.help : Topicz::CommandFactory.new.load_command(@command).help
    end

    def self.help
      commands = ""
      Topicz::COMMANDS.each_key {|command| commands = commands + "- #{command}\n"}
      "Shows help about a specific command. Valid commands are: \n\n#{commands}"
    end
  end
end
