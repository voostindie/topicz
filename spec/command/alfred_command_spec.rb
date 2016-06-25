require 'spec_helper'
require 'testdata'
require 'topicz/commands/alfred_command'

describe Topicz::Commands::AlfredCommand do

  it 'produces an empty items array in JSON in case of 0 matches' do
    with_testdata do
      expected = {items: []}.to_json + "\n"
      expect { Topicz::Commands::AlfredCommand.new(nil, ['zzz']).execute }.to output(expected).to_stdout
    end
  end

  it 'produces an array with all items in case of an empty filter' do
    with_testdata do
      expected = {items: [
          {
              uid: 'topic_1',
              type: 'file',
              title: 'Special topic',
              subtitle: 'Browse topic \'Special topic\' in Alfred Browser',
              arg: '/topics/topic1',
              icon: {
                  type: 'fileicon',
                  path: '/topics/topic1'
              },
              mods: {
                  cmd: {
                      subtitle: 'Open topic \'Special topic\' in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic \'Special topic\' in editor'
                  }
              }
          },
          {
              uid: 'other',
              type: 'file',
              title: 'Other topic',
              subtitle: 'Browse topic \'Other topic\' in Alfred Browser',
              arg: '/topics/other',
              icon: {
                  type: 'fileicon',
                  path: '/topics/other'
              },
              mods: {
                  cmd: {
                      subtitle: 'Open topic \'Other topic\' in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic \'Other topic\' in editor'
                  }
              }
          },
          {
              uid: 'third',
              type: 'file',
              title: 'third',
              subtitle: 'Browse topic \'third\' in Alfred Browser',
              arg: '/topics/third',
              icon: {
                  type: 'fileicon',
                  path: '/topics/third'
              },
              mods: {
                  cmd: {
                      subtitle: 'Open topic \'third\' in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic \'third\' in editor'
                  }
              }
          },
          {
              uid: '4',
              type: 'file',
              title: 'fourth',
              subtitle: 'Browse topic \'fourth\' in Alfred Browser',
              arg: '/topics/fourth',
              icon: {
                  type: 'fileicon',
                  path: '/topics/fourth'
              },
              mods: {
                  cmd: {
                      subtitle: 'Open topic \'fourth\' in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic \'fourth\' in editor'
                  }
              }
          }

      ]}.to_json + "\n"
      expect { Topicz::Commands::AlfredCommand.new.execute }.to output(expected).to_stdout
    end
  end

  it 'produces an array with one item in case of a strict filter' do
    with_testdata do
      expected = {items: [
          {
              uid: 'topic_1',
              type: 'file',
              title: 'Special topic',
              subtitle: 'Browse topic \'Special topic\' in Alfred Browser',
              arg: '/topics/topic1',
              icon: {
                  type: 'fileicon',
                  path: '/topics/topic1'
              },
              mods: {
                  cmd: {
                      subtitle: 'Open topic \'Special topic\' in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic \'Special topic\' in editor'
                  }
              }
          }
      ]}.to_json + "\n"
      expect { Topicz::Commands::AlfredCommand.new(nil, ['Special']).execute }.to output(expected).to_stdout
    end
  end

  it 'supports journal mode' do
    with_testdata do
      expected = {items: [
          {
              uid: 'topic_1',
              type: 'file',
              title: 'Special topic',
              subtitle: 'Open this weeks journal entry for topic \'Special topic\'',
              arg: 'topic_1',
              icon: {
                  type: 'fileicon',
                  path: '/topics/topic1'
              }
          }
      ]}.to_json + "\n"
      expect { Topicz::Commands::AlfredCommand.new(nil, ['-m', 'journal', 'Special']).execute }.to output(expected).to_stdout
    end
  end

  it 'supports note mode' do
    with_testdata do
      expected = {items: [
          {
              uid: 'topic_1',
              type: 'file',
              title: 'Special topic',
              subtitle: 'Create a new note for topic \'Special topic\'',
              arg: 'topic_1',
              icon: {
                  type: 'fileicon',
                  path: '/topics/topic1'
              }
          }
      ]}.to_json + "\n"
      expect { Topicz::Commands::AlfredCommand.new(nil, ['-m', 'note', 'Special']).execute }.to output(expected).to_stdout
    end
  end

  it 'raises an error on an unknown mode' do
    with_testdata do
      expect {
        Topicz::Commands::AlfredCommand.new(nil, ['-m', 'unsupported', 'Special']).execute
      }.to raise_error(/Invalid mode: 'unsupported'/)
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::AlfredCommand.new.option_parser.to_s).to include 'produces the result in JSON for Alfred'
  end
end