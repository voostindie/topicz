require 'spec_helper'
require 'testdata'
require 'topicz/repository'

describe Topicz::Repository do

  it 'should load topics from disk' do
    FakeFS do
      FakeFS::FileSystem.add('/topics')
      FakeFS::FileSystem.add('/topics/topic1')
      FakeFS::FileSystem.add('/topics/topic2')
      FakeFS::FileSystem.add('/topics/topic3')
      repository = Topicz::Repository.new('/topics')
      expect(repository.topics.length).to be 3
    end
  end

  it 'should read a topic YAML file' do
    with_testdata do
      @repository = Topicz::Repository.new('/topics')
      topic = @repository.topics[0]
      expect(topic.id).to eq 'topic_1'
      expect(topic.title).to eq 'Special topic'
      expect(topic.fullpath).to eq '/topics/topic1'
    end
  end

  it 'should find a topic based on the path' do
    with_testdata do
      @repository = Topicz::Repository.new('/topics')
      topics = @repository.find_all('topic1')
      expect(topics.length).to be 1
      expect(topics[0].id).to eq 'topic_1'
    end
  end

  it 'should find a topic based on the title' do
    with_testdata do
      @repository = Topicz::Repository.new('/topics')
      topics = @repository.find_all('Special topic')
      expect(topics.length).to be 1
      expect(topics[0].id).to eq 'topic_1'
    end
  end

  it 'should find a topic based on an alias' do
    with_testdata do
      @repository = Topicz::Repository.new('/topics')
      topics = @repository.find_all('alias1')
      expect(topics.length).to be 1
      expect(topics[0].id).to eq 'topic_1'
    end
  end

  it 'should find all topics with an empty search filter' do
    with_testdata do
      @repository = Topicz::Repository.new('/topics')
      topics = @repository.find_all
      expect(topics.length).to be 3
    end
  end
end