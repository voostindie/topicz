module Topicz

  COMMANDS = {
      'init' => 'Initializes a new topic repository',
      'help' => 'Shows help about a command',
  }

  class CommandFactory

    def load_command(name)
      unless COMMANDS.has_key?name
        raise "Unsupported command: #{name}"
      end
      require "topicz/command/#{name}"
      Object.const_get("Topicz::Command::#{name.capitalize}")
    end

    def create_command(name, arguments = [])
      load_command(name).new.prepare(arguments)
    end

  end

end
