require 'spec_helper'
require 'topicz/commands/stats_command'

describe Topicz::Commands::StatsCommand do

  it 'generates no output if no changes were made' do
    with_testdata do
      expect {
        Topicz::Commands::StatsCommand.new(nil, %w(-y 2000 -w 1)).execute
      }.to output('').to_stdout
    end
  end

  it 'generates statistics on Documents, Notes and Reference Material' do
    expected =<<EOF
Special topic
* Documents/2001-01-05 Presentation.pptx
* Notes/2001-01-01 Note 1.md
* Reference Material/2001-01-03 Report.pdf
EOF
    with_testdata do
      expect {
        Topicz::Commands::StatsCommand.new(nil, %w(-y 2001 -w 1)).execute
      }.to output(expected).to_stdout
    end
  end

  it 'generates statistics on across topics' do
    expected =<<EOF
third
* Notes/2002-01-01 Note 1.md

fourth
* Notes/2002-01-01 Note 1.md
EOF
    with_testdata do
      expect {
        Topicz::Commands::StatsCommand.new(nil, %w(-y 2002 -w 1)).execute
      }.to output(expected).to_stdout
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::StatsCommand.new.option_parser.to_s).to include 'Generates weekly statistics'
  end

end
