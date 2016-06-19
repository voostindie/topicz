require 'spec_helper'
require 'topicz/commands/repository_command'

describe Topicz::Commands::RepositoryCommand do

  it 'raises an error if the repository in the configuration file doesn\t exist' do
    expect {
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'repository: /tmp')
        Topicz::Commands::RepositoryCommand.new
      end
    }.to raise_error(/Repository directory doesn't exist: \/tmp./)
  end

  it 'raises an error if the configuration file is missing' do
    expect {
      FakeFS do
        Topicz::Commands::RepositoryCommand.new
      end
    }.to raise_error(/File doesn't exist:/)
  end

  it 'raises an error if the configuration file is not a YAML file' do
    expect {
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, '@foo')
        Topicz::Commands::RepositoryCommand.new
      end
    }.to raise_error(/Not a valid YAML file:/)
  end

  it 'raises an error if the configuration file is missing' do
    expect {
      FakeFS do
        Topicz::Commands::RepositoryCommand.new
        fail('Should raise an exception...')
      end
    }.to raise_error(/File doesn't exist:/)
  end

  it 'raises an error if the configuration file is not a YAML file' do
    expect {
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, '@foo')
        Topicz::Commands::RepositoryCommand.new
      end
    }.to raise_error(/Not a valid YAML file:/)
  end

  it 'raises an error if the configuration doesn\'t specify a repository' do
    expect {
      FakeFS do
        FakeFS::FileSystem.add(Dir.home)
        File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'foo: bar')
        Topicz::Commands::RepositoryCommand.new
        fail('Should raise an exception...')
      end
    }.to raise_error(/Missing required property 'repository'/)
  end

end
