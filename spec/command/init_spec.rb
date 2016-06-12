require 'spec_helper'
require 'topicz/command/init'

describe Topicz::Command::Init do

  it 'requires one argument' do
    begin
      Topicz::Command::Init.new.prepare
      fail
    rescue Exception => e
      expect(e.message).to eq 'Pass the location of the new repository as an argument.'
    end
  end

  it 'fails to run when the directory already exists' do
    begin
      FakeFS do
        FakeFS::FileSystem.add('/tmp')
        Topicz::Command::Init.new.prepare(['/tmp']).execute
      end
      fail
    rescue Exception => e
      expect(e.message).to eq 'A file or directory already exists at this location: /tmp.'
    end
  end

  it 'executes when the directory doesn\'t yet exist' do
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      expect(Topicz::Command::Init.new.prepare(['/tmp']).execute).to be true
    end
  end

  it 'skips creation of the configuration file if one already exists' do
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      File.write(Topicz::DEFAULT_CONFIG_LOCATION, 'foo')
      expect(Topicz::Command::Init.new.prepare(['/tmp']).create_configuration).to be false
    end
  end

  it 'creates a configuration file if none exists' do
    FakeFS do
      FakeFS::FileSystem.add(Dir.home)
      expect(Topicz::Command::Init.new.prepare(['/tmp']).create_configuration).to be true
    end
  end

  it 'supports an alternative configuration file' do
    FakeFS do
      expect(Topicz::Command::Init.new.prepare(['-c', '/config', '/tmp']).create_configuration).to be true
      expect(File.exist? '/config').to be true
    end
  end

  it 'doesn\'t require a configuration' do
    expect(Topicz::Command::Init.new.prepare(["/tmp"]).requires_config?).to be false
  end

  it 'supports help' do
    expect(Topicz::Command::Init.new.help).to include 'Initializes a new topic repository.'
  end
end
