require 'spec_helper'
require 'testdata'
require 'topicz/commands/journal_command'

class DummyKernel
  def exec(*arguments)
    print arguments.join ' '
  end
end

describe Topicz::Commands::JournalCommand do

  it 'creates a file with the proper heading when needed' do
    year = Date.today.cwyear.to_s
    week = Date.today.cweek.to_s.rjust(2, '0')
    with_testdata do
      filename = "/topics/topic1/Journal/#{year}-week-#{week}.md"
      expect {
        Topicz::Commands::JournalCommand.new(nil, %w(-s topic_1), DummyKernel.new).execute
      }.to output("foo-editor \"#{filename}\"").to_stdout
      expect(File.exist?(filename)).to be true
      expect(File.readlines(filename)[0]).to eq "# Special topic - Week #{week}, 2016\n"
    end
  end

  it 'skips file creation when one already exists' do
    year = Date.today.cwyear.to_s
    week = Date.today.cweek.to_s.rjust(2, '0')
    filename = "/topics/topic1/Journal/#{year}-week-#{week}.md"
    with_testdata do
      FakeFS::FileSystem.add('/topics/topic1/Journal')
      File.write(filename, 'DUMMY FILE')
      expect {
        Topicz::Commands::JournalCommand.new(nil, %w(-s topic_1), DummyKernel.new).execute
      }.to output("foo-editor \"#{filename}\"").to_stdout
      expect(File.exist?(filename)).to be true
      expect(File.readlines(filename)[0]).to eq 'DUMMY FILE'
    end
  end

  it 'does a strict ID match when using --strict' do
    year = Date.today.cwyear.to_s
    week = Date.today.cweek.to_s.rjust(2, '0')
    with_testdata do
      expect {
        Topicz::Commands::JournalCommand.new(nil, %w(-s topic_1), DummyKernel.new).execute
      }.to output("foo-editor \"/topics/topic1/Journal/#{year}-week-#{week}.md\"").to_stdout
    end
  end

  it 'allows a specific year to be set' do
    week = Date.today.cweek.to_s.rjust(2, '0')
    with_testdata do
      expect {
        Topicz::Commands::JournalCommand.new(nil, %w(-s -y 2000 topic_1), DummyKernel.new).execute
      }.to output("foo-editor \"/topics/topic1/Journal/2000-week-#{week}.md\"").to_stdout
    end
  end

  it 'allows a specific week to be set' do
    year = Date.today.cwyear.to_s
    with_testdata do
      expect {
        Topicz::Commands::JournalCommand.new(nil, %w(-s -w 1 topic_1), DummyKernel.new).execute
      }.to output("foo-editor \"/topics/topic1/Journal/#{year}-week-01.md\"").to_stdout
    end
  end


  it 'supports help' do
    expect(Topicz::Commands::JournalCommand.new.option_parser.to_s).to include 'Opens the weekly journal'
  end

end