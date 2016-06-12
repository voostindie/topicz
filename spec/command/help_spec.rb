require 'spec_helper'
require 'topicz/command/help'

describe Topicz::Command::Help do

  it 'prints a list of commands when none is given' do
    Topicz::Command::Help.new.prepare.execute

  end

  it 'prints information on a single command when one is given' do
    Topicz::Command::Help.new.prepare(['help']).execute
  end

  it 'doesn\'t require a configuration' do
    expect(Topicz::Command::Help.new.requires_config?).to be false
  end

end
