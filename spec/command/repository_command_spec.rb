require 'spec_helper'
require 'topicz/commands/repository_command'

describe Topicz::Commands::RepositoryCommand do

  it 'raises an error if the repository in the configuration file doesn\t exist' do
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'repository: /tmp')
        Topicz::Commands::RepositoryCommand.new
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq 'Repository directory doesn\'t exist: /tmp.'
    end
  end

  it 'raises an error if the configuration file is missing' do
    begin
      FakeFS do
        Topicz::Commands::RepositoryCommand.new
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "File doesn't exist: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

  it 'raises an error if the configuration file is not a YAML file' do
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, '@foo')
        Topicz::Commands::RepositoryCommand.new
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "Not a valid YAML file: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

  it 'raises an error if the configuration file is missing' do
    begin
      FakeFS do
        Topicz::Commands::RepositoryCommand.new
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "File doesn't exist: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

  it 'raises an error if the configuration file is not a YAML file' do
    begin
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, '@foo')
        Topicz::Commands::RepositoryCommand.new
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
        Topicz::Commands::RepositoryCommand.new
        fail('Should raise an exception...')
      end
    rescue Exception => e
      expect(e.message).to eq "Missing required property 'repository' in configuration file: #{Topicz::DEFAULT_CONFIG_LOCATION}."
    end
  end

end
