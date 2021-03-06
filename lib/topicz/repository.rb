require 'yaml'

module Topicz

  class Repository

    attr_reader :root

    def initialize(root, exclude_filters = [])
      @root = root
      @topics = {}
      errors = []
      excludes = exclude_filters.map { | filter | Regexp.new(filter) }
      Dir.foreach(root) do |path|
        next if path.start_with?('.')
        next if excludes.any? { | regexp | path =~ regexp }
        next unless File.directory?(File.join(root, path))
        topic = Topic.new(root, path)
        if @topics.has_key?(topic.id)
          errors << "Error in topic '#{topic.title}': ID '#{topic.id}' is already in use."
        end
        @topics[topic.id] = topic
      end
      @topics.each_value do |topic|
        topic.references.each do |ref|
          unless @topics.has_key?(ref)
            errors << "Error in topic '#{topic.title}': Reference to non-existing topic ID '#{ref}'."
          end
        end
      end
      unless errors.empty?
        raise errors
      end
    end

    def [](id)
      @topics[id]
    end

    def exist_title?(title)
      @topics.values.any? { |t| t.title == title }
    end

    def topics
      @topics.values
    end

    def find_all(filter = nil)
      @topics.values.select { |t| t.matches(filter) }
    end

  end

  class Topic

    attr_reader :id, :path, :title, :category, :aliases, :metadata

    def initialize(root, path)
      @root = root
      @path = path

      descriptor = File.join(@root, @path, 'topic.yaml')
      yaml = if File.exist?(descriptor)
               YAML.load_file(descriptor)
             else
               {}
             end

      @id = yaml['id'] || create_id(path)
      @category = yaml['category'] || 'none'
      @title = yaml['title'] || @path
      @aliases = yaml['aliases'] || []
      @parents = yaml['depends on'] || {}
      @relations = yaml['relates to'] || {}
      @metadata = yaml['metadata'] || {}
    end

    # Checks whether this topic's title or one of its aliases matches the filter
    # The filter may be `nil`, in which case it is said to match.
    def matches(filter)
      return true unless filter
      filter = filter.downcase
      @title.downcase.include?(filter) ||
          @id.downcase.include?(filter) ||
          !(@aliases.select { |a| a.downcase.include?(filter) }.empty?) ||
          @path.downcase.include?(filter)
    end

    # Full path to this topic on disk
    def fullpath
      File.join(@root, @path)
    end

    # List of unique topic IDs that this topic refers to.
    def references
      @parents.keys
    end

    def parents
      @parents.keys
    end

    def relations
      @relations.keys
    end

    def to_s
      <<-EOS
Topic '#{@id}' {
  title: '#{@title}',
  aliases: '#{@aliases}',
  category: '#{@category}',
  parents: #{@parents},
  relations: #{@relations}
}
      EOS
    end

    private
    def create_id(path)
      path.downcase.gsub(/[\_,;\.\&]/, '').gsub(/[ ]/, '-').gsub(/\-\-/, '-')
    end
  end

end