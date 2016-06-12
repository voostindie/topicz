require 'spec_helper'

class DummyCommandFactory
  def create_command(name, arguments = [])
    name
  end
end

cf = DummyCommandFactory.new

describe Topicz do
  it 'has a version number' do
    expect(Topicz::VERSION).not_to be nil
  end

  it 'prints help when called with -h' do
    begin
      Topicz.create_command(['-h'], cf)
    rescue Exception => e
      expect(e.message).to eq 'exit'
    end
  end

  it 'returns nil when no command is specified' do
    expect(Topicz.create_command([], cf)).to be nil
  end

  it 'returns nil when an unsupported command is specified' do
    expect(Topicz.create_command(['foo'], cf)).to be nil
  end

  it 'returns a command when a valid command is specified' do
    expect(Topicz.create_command(['init'], cf)).to eq 'init'
  end

  it 'accepts an alternative configuration file location' do
    Topicz.config_file = nil
    expect(Topicz.create_command(['-c', '/tmp/foo', 'init'], cf)).not_to be nil
    expect(Topicz.config_file).to eq '/tmp/foo'
  end

  it 'loads the default configuration if none is specified' do
    Topicz.config_file = nil
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'repository: /tmp')
      FakeFS::FileSystem.add('/tmp')
      expect(Topicz.load_config).not_to be nil
    end
  end

  it 'raises an error if the configuration file is missing' do
    Topicz.config_file = nil
    begin
      FakeFS do
        Topicz.load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "File doesn't exist: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

  it 'raises an error if the repository in the configuration file is invalid' do
    Topicz.config_file = nil
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'repository: /tmp')
        Topicz.load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq 'Repository directory doesn\'t exist: /tmp.'
    end
  end

  it 'raises an error if the configuration file is not a YAML file' do
    Topicz.config_file = nil
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, '@foo')
        Topicz.load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "Not a valid YAML file: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

  it 'raises an error if the configuration doesn\'t specify a repository' do
    Topicz.config_file = nil
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'foo: bar')
        Topicz.load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "Missing required property 'repository' in configuration file: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end
end
