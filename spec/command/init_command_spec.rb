require 'spec_helper'
require 'topicz/commands/init_command'

describe Topicz::Commands::InitCommand do

  it 'requires one argument' do
    begin
      Topicz::Commands::InitCommand.new.execute
      fail
    rescue Exception => e
      expect(e.message).to eq 'Pass the location of the new repository as an argument.'
    end
  end

  it 'fails to run when the directory already exists' do
    begin
      FakeFS do
        FakeFS::FileSystem.add('/tmp')
        Topicz::Commands::InitCommand.new({}, ['/tmp']).execute
      end
      fail
    rescue Exception => e
      expect(e.message).to eq 'A file or directory already exists at this location: /tmp.'
    end
  end

  it 'executes when the directory doesn\'t yet exist' do
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      expect {
        Topicz::Commands::InitCommand.new({}, ['/tmp']).execute
      }.to output(/New topic repository created/).to_stdout
    end
  end

  it 'skips creation of the configuration file if one already exists' do
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'foo')
      init = Topicz::Commands::InitCommand.new({}, ['/tmp'])
      expect { init.create_configuration }.to output(/Skipping creation of configuration file/).to_stdout
    end
  end

  it 'creates a configuration file if none exists' do
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      init = Topicz::Commands::InitCommand.new({}, ['/tmp'])
      expect { init.create_configuration }.to output(/#{Topicz::DEFAULT_CONFIG_LOCATION}/).to_stdout
    end
  end

  it 'supports an alternative configuration file' do
    FakeFS do
      init = Topicz::Commands::InitCommand.new({}, %w(-c /config /tmp))
      expect { init.create_configuration }.to output(/\/config/).to_stdout
      expect(File.exist? '/config').to be true
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::InitCommand.new.option_parser.to_s).to include 'Initializes a new topic repository.'
  end
end
