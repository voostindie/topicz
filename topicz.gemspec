# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'topicz/version'

Gem::Specification.new do |spec|
  spec.name          = "topicz"
  spec.version       = Topicz::VERSION
  spec.authors       = ["Vincent Oostindië"]
  spec.email         = ["vincent@ulso.nl"]

  spec.summary       = %q{Filesystem based topic administration tool}
  spec.description   = %q{Topicz is a filesystem based topic administration tool. All it does is manipulate files and directories. But it does so in a structured way, helping you to keep track of your own documents, reference material, and topic relationships.}
  spec.homepage      = "https://github.com/voostindie/topicz"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "'http://localhost:8081'" # Local Nexus instance
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0" # this one works with the IntelliJ Rake Runner plugin
  spec.add_development_dependency "simplecov", "~> 0.11.2"
  spec.add_development_dependency "fakefs", "~> 0.8.1"
end
