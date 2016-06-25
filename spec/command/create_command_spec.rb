require 'spec_helper'
require 'testdata'
require 'topicz/commands/create_command'

describe Topicz::Commands::CreateCommand do

  it 'raises an error when a topic with the specified name already exists' do
    with_testdata do
      expect {
        Topicz::Commands::CreateCommand.new(nil, ['Special topic']).execute
      }.to raise_error(/Topic already exists: 'Special topic'/)
    end
  end

  it 'raises an error when a directory with the specified name already exists' do
    with_testdata do
      expect {
        Topicz::Commands::CreateCommand.new(nil, ['other']).execute
      }.to raise_error(/Directory already exists: 'other'/)
    end
  end

  it 'creates a directory structure for a new topic' do
    with_testdata do
      expect {
        Topicz::Commands::CreateCommand.new(nil, ['new']).execute
      }.to output(/Created topic 'new'/).to_stdout
      expect(File.exist?('/topics/new')).to be true
      expect(File.exist?('/topics/new/Documents')).to be true
      expect(File.exist?('/topics/new/Journal')).to be true
      expect(File.exist?('/topics/new/Notes')).to be true
      expect(File.exist?('/topics/new/Reference')).to be true
      expect(File.exist?('/topics/new/topic.yaml')).to be false
    end
  end

  it 'sanitizes the name for the title' do
    with_testdata do
      expect {
        Topicz::Commands::CreateCommand.new(nil, [':A:B:']).execute
      }.to output(/Created topic ':A:B:'/).to_stdout
      expect(File.exist?('/topics/AB')).to be true
      expect(File.exist?('/topics/AB/topic.yaml')).to be true
      expect(YAML.load_file('/topics/AB/topic.yaml')['title']).to eq(':A:B:')
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::CreateCommand.new.option_parser.to_s).to include 'Creates a new topic'
  end
end