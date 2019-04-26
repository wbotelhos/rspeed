# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rspeed/version'

Gem::Specification.new do |spec|
  spec.author      = 'Washington Botelho'
  spec.description = 'Split and speed up your RSpec tests.'
  spec.email       = 'wbotelhos@gmail.com'
  spec.files       = Dir['lib/**/*'] + %w[CHANGELOG.md LICENSE README.md]
  spec.homepage    = 'https://github.com/wbotelhos/rspeed'
  spec.license     = 'MIT'
  spec.name        = 'rspeed'
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = 'Split and speed up your RSpec tests.'
  spec.test_files  = Dir['spec/**/*']
  spec.version     = RSpeed::VERSION

  spec.add_development_dependency 'fakeredis'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-rspec'
end
