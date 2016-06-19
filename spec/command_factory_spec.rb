require 'spec_helper'
require 'topicz/command_factory'

describe Topicz::CommandFactory do

  it 'dynamically loads a command class' do
    expect(Topicz::CommandFactory.new.load_command 'help').not_to be nil
  end

  it 'instantiates commands that can be executed' do
    expect(Topicz::CommandFactory.new.create_command 'help').not_to be nil
  end

  it 'accepts only known commands' do
    expect {
      Topicz::CommandFactory.new.load_command 'foo'
    }.to raise_error(/Unsupported command: foo/)
  end

end
