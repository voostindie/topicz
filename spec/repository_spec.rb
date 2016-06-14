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
    FakeFS do
      FakeFS::FileSystem.add('/topics')
      FakeFS::FileSystem.add('/topics/topic1')
      FakeFS::File.write('/topics/topic1/topic.yaml', YAML.dump(
          {
              'id' => 'topic_1',
              'title' => 'Special topic'
          }
      ))
      repository = Topicz::Repository.new('/topics')
      topic = repository.topics[0]
      expect(topic.id).to eq 'topic_1'
      expect(topic.title).to eq 'Special topic'
      expect(topic.fullpath).to eq '/topics/topic1'
    end
  end
end