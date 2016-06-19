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
              uid: '/topics/topic1',
              type: 'file',
              title: 'Special topic',
              subtitle: 'Browse topic in Alfred Browser',
              arg: '/topics/topic1',
              mods: {
                  cmd: {
                      subtitle: 'Open topic in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic in editor'
                  }
              },
              icon: {
                  type: 'fileicon',
                  path: '/topics/topic1'
              }
          },
          {
              uid: '/topics/other',
              type: 'file',
              title: 'Other topic',
              subtitle: 'Browse topic in Alfred Browser',
              arg: '/topics/other',
              mods: {
                  cmd: {
                      subtitle: 'Open topic in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic in editor'
                  }
              },
              icon: {
                  type: 'fileicon',
                  path: '/topics/other'
              }
          },
          {
              uid: '/topics/third',
              type: 'file',
              title: 'third',
              subtitle: 'Browse topic in Alfred Browser',
              arg: '/topics/third',
              mods: {
                  cmd: {
                      subtitle: 'Open topic in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic in editor'
                  }
              },
              icon: {
                  type: 'fileicon',
                  path: '/topics/third'
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
              uid: '/topics/topic1',
              type: 'file',
              title: 'Special topic',
              subtitle: 'Browse topic in Alfred Browser',
              arg: '/topics/topic1',
              mods: {
                  cmd: {
                      subtitle: 'Open topic in Finder'
                  },
                  alt: {
                      subtitle: 'Open topic in editor'
                  }
              },
              icon: {
                  type: 'fileicon',
                  path: '/topics/topic1'
              }
          }
      ]}.to_json + "\n"
      expect { Topicz::Commands::AlfredCommand.new(nil, ['Special']).execute }.to output(expected).to_stdout
    end
  end

  it 'supports help' do
    expect(Topicz::Commands::AlfredCommand.new.option_parser.to_s).to include 'produces the result in JSON for Alfred'
  end
end