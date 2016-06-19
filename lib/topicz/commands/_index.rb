module Topicz

  COMMANDS = {
      'init' => 'Initializes a new topic repository',
      'help' => 'Shows help about a command',
      'alfred' => 'Searches in Alfred Script Filter format',
      'path' => 'Prints the full path to a topic'
  }

  def COMMANDS.to_s
    COMMANDS.collect { |command, description| "  #{command.ljust(7)}: #{description}" }.join("\n")
  end

end
