require 'spec_helper'
require 'topicz/application'

class DummyCommandFactory
  def create_command(name, arguments = [])
    name
  end
end

cf = DummyCommandFactory.new

describe Topicz::Application do

  it 'prints help when called with -h' do
    begin
      expect { Topicz::Application.new(['-h'], cf) }.to output(/Usage: topicz/).to_stdout
    rescue Exception => e
      expect(e.message).to eq 'exit'
    end
  end

  it 'has no command when no command is specified' do
    expect(Topicz::Application.new([], cf).command).to be nil
  end

  it 'has no command when an unsupported command is specified' do
    expect(Topicz::Application.new(['foo'], cf).command).to be nil
  end

  it 'has a command when a valid command is specified' do
    expect(Topicz::Application.new(['init'], cf).command).to eq 'init'
  end

  it 'accepts an alternative configuration file location' do
    app = Topicz::Application.new(['-c', '/tmp/foo', 'init'], cf)
    expect(app.config_file).not_to be nil
    expect(app.config_file).to eq '/tmp/foo'
  end

  it 'loads the default configuration if none is specified' do
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'repository: /tmp')
      FakeFS::FileSystem.add('/tmp')
      expect(Topicz::Application.new([])).not_to be nil
    end
  end

  it 'raises an error if the configuration file is missing' do
    begin
      FakeFS do
        Topicz::Application.new([]).load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "File doesn't exist: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

  it 'raises an error if the repository in the configuration file is invalid' do
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'repository: /tmp')
        Topicz::Application.new([]).load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq 'Repository directory doesn\'t exist: /tmp.'
    end
  end

  it 'raises an error if the configuration file is not a YAML file' do
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, '@foo')
        Topicz::Application.new([]).load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "Not a valid YAML file: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

  it 'raises an error if the configuration doesn\'t specify a repository' do
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'foo: bar')
        Topicz::Application.new([]).load_config
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "Missing required property 'repository' in configuration file: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end
end
