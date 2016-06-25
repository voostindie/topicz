require_relative 'repository_command'

module Topicz::Commands

  class EditorCommand < RepositoryCommand

    def editor
      @config['editor'] ||
          ENV['EDITOR'] ||
          raise('No editor configured. Set one in the topicz configuraton file, or in the EDITOR environment variable.')
    end

  end
end