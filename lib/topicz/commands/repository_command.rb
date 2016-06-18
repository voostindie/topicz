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
      Repository.new(directory)
    end
  end
end
