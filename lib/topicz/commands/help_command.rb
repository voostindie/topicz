require_relative 'base_command'
require 'topicz/command_factory'

module Topicz::Commands

  class HelpCommand < BaseCommand

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: help <command>'
        options.separator ''
        options.separator 'Shows help about a specific command. Valid commands are:'
        options.separator ''
        options.separator Topicz::COMMANDS.to_s
      end
    end

    def requires_config?
      false
    end

    def init
      option_parser.order! @arguments
      @help =
          if @arguments.empty?
            self
          else
            Topicz::CommandFactory.new.load_command(@arguments.shift).new
          end.option_parser
    end

    def run
      puts @help.help
    end
  end
end
