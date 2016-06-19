def with_testdata(&block)
  FakeFS do
    FakeFS::FileSystem.add(Dir.home)
    FakeFS::File.write(File.join(Dir.home, '.topiczrc'), YAML.dump(
        {
            'repository' => '/topics'
        }
    ))
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
    yield block
  end
end