require 'spec_helper'
require 'topicz/application'
require 'topicz/commands/repository_command'

class DummyCommandFactory
  def create_command(name, config, arguments = [])
    if name == 'init'
      DummyInitCommand.new
    else
      name
    end
  end
end

class DummyInitCommand
  def execute
    'Init command executed'
  end
end

factory = DummyCommandFactory.new

describe Topicz::Application do

  it 'prints help when called with -h' do
    begin
      expect { Topicz::Application.new(['-h'], factory) }.to output(/Usage: topicz/).to_stdout
    rescue Exception => e
      expect(e.message).to eq 'exit'
    end
  end

  it 'has no command when no command is specified' do
    expect(Topicz::Application.new([], factory).command).to be nil
  end

  it 'has no command when an unsupported command is specified' do
    expect(Topicz::Application.new(['foo'], factory).command).to be nil
  end

  it 'has a command when a valid command is specified' do
    expect(Topicz::Application.new(['help'], factory).command).to eq 'help'
  end

  it 'runs the command specified as an argument' do
    app = Topicz::Application.new(['init'], factory)
    expect(app.run).to eq 'Init command executed'
  end

end
