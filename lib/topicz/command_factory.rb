require 'topicz/commands/_index'

module Topicz

  class CommandFactory

    def load_command(name)
      unless COMMANDS.has_key?name
        raise "Unsupported command: #{name}"
      end
      require "topicz/commands/#{name}_command"
      Object.const_get("Topicz::Commands::#{name.capitalize}Command")
    end

    def create_command(name, config_file = nil, arguments = [])
      load_command(name).new(config_file, arguments)
    end

  end

end
