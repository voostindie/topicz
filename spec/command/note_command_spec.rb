require 'spec_helper'
require 'testdata'
require 'topicz/commands/note_command'

class DummyKernel
  def exec(*arguments)
    print arguments.join ' '
  end
end

describe Topicz::Commands::NoteCommand do

  it 'creates a file with the proper heading when needed' do
    with_testdata do
      date = DateTime.now.strftime("%Y-%m-%d")
      filename = "/topics/topic1/Notes/#{date} Foo.md"
      expect {
        Topicz::Commands::NoteCommand.new(nil, %w(-s topic_1 Foo), DummyKernel.new).execute
      }.to output("foo-editor \"#{filename}\"").to_stdout
      expect(File.exist?(filename)).to be true
      expect(File.readlines(filename)[0]).to eq "# Special topic - Foo\n"
    end
  end

  it 'includes the hour and minute if no name is specified' do
    with_testdata do
      date = DateTime.now.strftime("%Y-%m-%d %H%M")
      filename = "/topics/topic1/Notes/#{date}.md"
      expect {
        Topicz::Commands::NoteCommand.new(nil, %w(-s topic_1), DummyKernel.new).execute
      }.to output("foo-editor \"#{filename}\"").to_stdout
      expect(File.exist?(filename)).to be true
      expect(File.readlines(filename)[0]).to eq "# Special topic - Unnamed note\n"
    end
  end

  it 'skips file creation when one already exists' do
    with_testdata do
      date = DateTime.now.strftime("%Y-%m-%d")
      filename = "/topics/topic1/Notes/#{date} Foo.md"
      FakeFS::FileSystem.add('/topics/topic1/Notes')
      File.write(filename, 'DUMMY FILE')
      expect {
        Topicz::Commands::NoteCommand.new(nil, %w(-s topic_1 Foo), DummyKernel.new).execute
      }.to output("foo-editor \"#{filename}\"").to_stdout
      expect(File.exist?(filename)).to be true
      expect(File.readlines(filename)[0]).to eq 'DUMMY FILE'
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::NoteCommand.new.option_parser.to_s).to include 'Creates a new note'
  end

end