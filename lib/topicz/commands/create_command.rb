require_relative 'repository_command'
require 'topicz/defaults'
require 'json'
require 'zaru'
require 'fileutils'

module Topicz::Commands
  class CreateCommand < RepositoryCommand

    def initialize(config_file = nil, arguments = [])
      super(config_file)
      @title = arguments.join(' ').strip
    end

    def option_parser
      OptionParser.new do |options|
        options.banner = 'Usage: create <name>'
        options.separator ''
        options.separator 'Creates a new topic with the specified name'
        options.separator ''
        options.separator 'Basically all this command does is create a new directory structure to hold a topic.'
        options.separator ''
        options.separator 'It is an error if a topic with the specified name already exists.'
      end
    end

    def execute
      if @repository.exist_title?(@title)
        raise "Topic already exists: '#{@title}'."
      end
      path = Zaru.sanitize! @title
      fullpath = File.join(@repository.root, path)
      if File.exist?(fullpath)
        raise "Directory already exists: '#{path}'."
      end
      FileUtils.mkdir fullpath
      Topicz::DIRECTORIES.each { |dir| FileUtils.mkdir(File.join(fullpath, dir)) }
      if path != @title
        File.open(File.join(fullpath, Topicz::TOPIC_FILE), 'w') do | file |
          file.write(YAML.dump({'title' => @title}))
        end
      end
      puts "Created topic '#{@title}'"
    end

  end
end
