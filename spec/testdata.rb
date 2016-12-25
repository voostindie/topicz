def with_testdata(&block)
  FakeFS do
    FakeFS::FileSystem.add(Dir.home)
    FakeFS::File.write(File.join(Dir.home, '.topiczrc'), YAML.dump(
        {
            'repository' => '/topics'
        }
    ))
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
    FakeFS::FileSystem.add('/topics/topic1/Documents/2001-01-05 Presentation.pptx')
    FakeFS::FileSystem.add('/topics/topic1/Notes/2001-01-01 Note 1.md')
    FakeFS::FileSystem.add('/topics/topic1/Reference Material/2001-01-03 Report.pdf')
    FakeFS::FileSystem.add('/topics/other')
    FakeFS::File.write('/topics/other/topic.yaml', YAML.dump(
        {
            'title' => 'Other topic'
        }
    ))
    FakeFS::FileSystem.add('/topics/third')
    FakeFS::FileSystem.add('/topics/third/Notes/2002-01-01 Note 1.md')
    FakeFS::FileSystem.add('/topics/fourth')
    FakeFS::FileSystem.add('/topics/fourth/Notes/2002-01-01 Note 1.md')
    FakeFS::File.write('/topics/fourth/topic.yaml', YAML.dump(
        {
            'id' => '4'
        }
    ))
    editor = ENV['EDITOR']
    ENV['EDITOR'] = 'foo-editor'
    yield block
    ENV['EDITOR'] = editor
  end
end