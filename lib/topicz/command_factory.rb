module Topicz

  COMMANDS = {
      'init' => 'Initializes a new topic repository',
      'help' => 'Shows help about a command',
  }

  def COMMANDS.to_s
    COMMANDS.collect { |command, description| "  #{command.ljust(6)}: #{description}" }.join("\n")
  end

  class CommandFactory

    def load_command(name)
      unless COMMANDS.has_key?name
        raise "Unsupported command: #{name}"
      end
      require "topicz/commands/#{name}_command"
      Object.const_get("Topicz::Commands::#{name.capitalize}Command")
    end

    def create_command(name, arguments = [])
      load_command(name).new(arguments)
    end

  end

end
