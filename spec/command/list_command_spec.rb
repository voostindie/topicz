require 'spec_helper'
require 'testdata'
require 'topicz/commands/list_command'

describe Topicz::Commands::ListCommand do

  it 'produces no output in case of 0 matches' do
    with_testdata do
      expect { Topicz::Commands::ListCommand.new(nil, ['zzz']).execute }.to output('').to_stdout
    end
  end

  it 'produces all items in case of an empty filter' do
    with_testdata do
      expected = "Special topic\nOther topic\nthird\nfourth\n"
      expect { Topicz::Commands::ListCommand.new.execute }.to output(expected).to_stdout
    end
  end

  it 'produces a single item in case of a strict filter' do
    with_testdata do
      expect { Topicz::Commands::ListCommand.new(nil, ['Special']).execute }.to output("Special topic\n").to_stdout
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::ListCommand.new.option_parser.to_s).to include 'Lists topics'
  end
end