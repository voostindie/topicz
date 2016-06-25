module Topicz

  COMMANDS = {
      'init'    => 'Initializes a new topic repository',
      'create'  => 'Creates a new topic',
      'path'    => 'Prints the full path to a topic',
      'journal' => 'Opens a (new) weekly journal entry for a topic',
      'note'    => 'Opens a new note for a topic',
      'alfred'  => 'Searches in Alfred Script Filter format',
      'report'  => 'Generates a weekly report of all topics',
      'help'    => 'Shows help about a command',
  }

  def COMMANDS.to_s
    COMMANDS.collect { |command, description| "  #{command.ljust(7)}: #{description}" }.join("\n")
  end

end
