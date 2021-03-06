# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gist_cleaner/version'

Gem::Specification.new do |spec|
  spec.name          = "gist_cleaner"
  spec.version       = GistCleaner::VERSION
  spec.authors       = ["HongliYu"]
  spec.email         = ["yhlssdone@gmail.com"]

  spec.summary       = %q{clean gist private, public, or both of them, with two-factor authentication or basic login}
  spec.description   = %q{clean gist private, public, or both of them, with two-factor authentication or basic login}
  spec.homepage      = "https://github.com/HongliYu/gist_cleaner"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   = ["gist_cleaner"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty", "~>0.13.7"
  spec.required_ruby_version = '>= 2.0.0'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
