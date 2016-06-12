$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fakefs/spec_helpers'
require 'topicz'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
  config.before(:each) {
    FakeFS::FileSystem.clear
  }
end
