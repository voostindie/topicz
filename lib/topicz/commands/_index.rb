module Topicz

  COMMANDS = {
      'init' => 'Initializes a new topic repository',
      'help' => 'Shows help about a command',
      'alfred' => 'Searches in Alfred Script Filter format'
  }

  def COMMANDS.to_s
    COMMANDS.collect { |command, description| "  #{command.ljust(6)}: #{description}" }.join("\n")
  end

end
