require 'topicz/defaults'
require 'topicz/repository'
require 'yaml'

module Topicz::Commands

  class RepositoryCommand

    def initialize(config_file = nil)
      @config = load_config(config_file)
      @repository = load_repository
    end

    def load_config(config_file)
      file = config_file != nil ? config_file : Topicz::DEFAULT_CONFIG_LOCATION
      unless File.exist? file
        raise "File doesn't exist: #{file}."
      end
      unless File.readable? file
        raise "File isn't readable: #{file}."
      end
      begin
        config = YAML.load_file(file)
      rescue
        raise "Not a valid YAML file: #{file}."
      end
      unless config.has_key?('repository')
        raise "Missing required property 'repository' in configuration file: #{file}."
      end
      config
    end

    def load_repository
      directory = @config['repository']
      unless Dir.exist? directory
        raise "Repository directory doesn't exist: #{directory}."
      end
      Topicz::Repository.new(directory, process_excludes(@config['excludes']))
    end

    def process_excludes(excludes_config)
      [excludes_config].compact.flatten
    end

    def find_exactly_one_topic(filter, strict)
      if strict
        topic = @repository[filter]
        if topic == nil
          raise "No topic found with ID: '#{filter}'"
        end
        topic
      else
        topics = @repository.find_all filter
        if topics.length == 0
          raise "No topics found matching the search filter: '#{filter}'"
        end
        if topics.length > 1
          matches = topics.map { |t| t.title }.join("\n")
          raise "Multiple topics match the search filter: '#{filter}'. Matches:\n#{matches}"
        end
        topics[0]
      end
    end
  end
end
