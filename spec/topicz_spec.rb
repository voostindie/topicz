require 'spec_helper'

describe Topicz do
  it 'has a version number' do
    expect(Topicz::VERSION).not_to be nil
  end

  it 'prints help when called with -h' do
    begin
      Topicz.create_command(['-h'])
    rescue Exception => e
      expect(e.message).to eq 'exit'
    end
  end

  it 'returns nil when no command is specified' do
    expect(Topicz.create_command([])).to be nil
  end

  it 'returns nil when an unsupported command is specified' do
    expect(Topicz.create_command(['foo'])).to be nil
  end

  it 'returns a command when a valid command is specificied' do
    expect(Topicz.create_command(['init'])).to eq 'init'
  end

  it 'raises an error when referring to an invalid file' do
    begin
      Topicz.create_command(['-c', '/tmp/foo'])
    rescue Exception => e
      expect(e.message).to eq 'File /tmp/foo doesn\'t exist'
    end
  end

  it 'accepts an alternative configuration file location' do
    expect(Topicz.create_command(['-c', 'Rakefile', 'init'])).not_to be nil
  end
end
