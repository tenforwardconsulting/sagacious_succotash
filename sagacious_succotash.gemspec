# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sagacious_succotash/version'

Gem::Specification.new do |spec|
  spec.name                   = "sagacious_succotash"
  spec.version                = SagaciousSuccotash::VERSION
  spec.authors                = ["Zach Boatrite"]
  spec.email                  = ["zach@tenforwardconsulting.com"]
  spec.summary                = %q{Sagacious Succotash is the rails app generator that we use at Ten Forward}
  spec.homepage               = "http://changeme.com"
  spec.license                = "MIT"
  spec.required_ruby_version  = '>= 2.2.2' # Same as rails' required ruby version

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', SagaciousSuccotash::RAILS_VERSION

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
