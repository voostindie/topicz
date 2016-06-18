require 'spec_helper'
require 'topicz/commands/help_command'

describe Topicz::Commands::HelpCommand do

  it 'prints a list of commands when none is given' do
    expect { Topicz::Commands::HelpCommand.new.execute }.to output(/help/).to_stdout
  end

  it 'prints information on a single command when one is given' do
    expect { Topicz::Commands::HelpCommand.new(['help']).execute }.to output(/help/).to_stdout
  end

end
