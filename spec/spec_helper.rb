$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pp' # Needed to fix fakefs (https://github.com/fakefs/fakefs/issues/99)
require 'topicz'
require 'topicz/defaults'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
  config.before(:each) do
    FakeFS::FileSystem.clear
  end
end
