require 'spec_helper'
require 'topicz/commands/editor_command'

describe Topicz::Commands::EditorCommand do

  it 'uses the system editor when none is specified in the configuration' do
    with_testdata do
      expect(Topicz::Commands::EditorCommand.new(nil).editor).to eq 'foo-editor'
    end
  end

  it 'uses the configured editor if one is specified' do
    with_testdata do
      FakeFS::File.write(File.join(Dir.home, '.topiczrc'), YAML.dump(
          {
              'repository' => '/topics',
              'editor' => 'bar-editor'
          }
      ))
      expect(Topicz::Commands::EditorCommand.new(nil).editor).to eq 'bar-editor'
    end
  end

  it 'raises an error when no editor is specified anywhere' do
    with_testdata do
      ENV['EDITOR'] = nil
      expect {
        Topicz::Commands::EditorCommand.new(nil).editor
      }.to raise_error(/No editor configured/)
    end
  end

end
