require 'spec_helper'
require 'testdata'
require 'topicz/commands/path_command'

describe Topicz::Commands::PathCommand do

  it 'raises an error when it matches multiple topics' do
    with_testdata do
      expect {
        Topicz::Commands::PathCommand.new(nil, []).execute
      }.to raise_error(/Multiple topics match/)
    end
  end

  it 'raises an error when it matches zero topics' do
    with_testdata do
      expect {
        Topicz::Commands::PathCommand.new(nil, ['zzz']).execute
      }.to raise_error(/No topics found/)
    end
  end


  it 'prints a path when it matches one topic' do
    with_testdata do
      expect {
        Topicz::Commands::PathCommand.new(nil, ['topic1']).execute
      }.to output('/topics/topic1').to_stdout
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::PathCommand.new.option_parser.to_s).to include 'Prints the absolute path'
  end
end