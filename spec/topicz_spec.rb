require 'spec_helper'

describe Topicz do
  it 'has a version number' do
    expect(Topicz::VERSION).not_to be nil
  end

  it 'prints help when called with -h' do
    Topicz.create_command(["-h"])

  end

  it 'creates the init command when called with init' do
    expect(Topicz.create_command(['init'])).to eq 'init'
  end

end
