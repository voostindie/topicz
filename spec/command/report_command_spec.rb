require 'spec_helper'
require 'topicz/commands/report_command'

describe Topicz::Commands::ReportCommand do

  it 'generates no output if no journals are present' do
    with_testdata do
      expect {
        Topicz::Commands::ReportCommand.new(nil, %w(-y 2000 -w 1)).execute
      }.to output('').to_stdout
    end
  end

  it 'collects journals for the current week' do
    expected =<<EOS
## Special topic

Some text

## Other topic

### Header

Text

EOS
    with_testdata do
      expect {
        year = Date.today.cwyear.to_s
        week = Date.today.cweek.to_s.rjust(2, '0')
        filename = "#{year}-week-#{week}.md"
        FakeFS::FileSystem.add('/topics/topic1/Journal')
        FakeFS::File.write(File.join('/topics/topic1/Journal', filename), "# Ignored\n\nSome text\n\n\n\n")
        FakeFS::FileSystem.add('/topics/other/Journal')
        FakeFS::File.write(File.join('/topics/other/Journal', filename), "# Ignored\n\n## Header\n\nText\n\n")

        Topicz::Commands::ReportCommand.new(nil).execute
      }.to output(expected).to_stdout
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::ReportCommand.new.option_parser.to_s).to include 'Generates a weekly report'
  end

end
