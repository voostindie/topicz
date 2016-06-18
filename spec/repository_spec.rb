require 'spec_helper'
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
    create_testdata
    topic = @repository.topics[0]
    expect(topic.id).to eq 'topic_1'
    expect(topic.title).to eq 'Special topic'
    expect(topic.fullpath).to eq '/topics/topic1'
  end

  it 'should find a topic based on the path' do
    create_testdata
    topics = @repository.find_all('topic1')
    expect(topics.length).to be 1
    expect(topics[0].id).to eq 'topic_1'
  end

  it 'should find a topic based on the title' do
    create_testdata
    topics = @repository.find_all('Special topic')
    expect(topics.length).to be 1
    expect(topics[0].id).to eq 'topic_1'
  end

  it 'should find a topic based on an alias' do
    create_testdata
    topics = @repository.find_all('alias1')
    expect(topics.length).to be 1
    expect(topics[0].id).to eq 'topic_1'
  end

  it 'should find all topics with an empty search filter' do
    create_testdata
    topics = @repository.find_all
    expect(topics.length).to be 3
  end

  def create_testdata
    FakeFS do
      FakeFS::FileSystem.add('/topics')
      FakeFS::FileSystem.add('/topics/topic1')
      FakeFS::File.write('/topics/topic1/topic.yaml', YAML.dump(
          {
              'id' => 'topic_1',
              'title' => 'Special topic',
              'aliases' => [
                  'alias1'
              ]
          }
      ))
      FakeFS::FileSystem.add('/topics/other')
      FakeFS::File.write('/topics/other/topic.yaml', YAML.dump(
          {
              'title' => 'Other topic'
          }
      ))
      FakeFS::FileSystem.add('/topics/third')
      @repository = Topicz::Repository.new('/topics')
    end
  end
end