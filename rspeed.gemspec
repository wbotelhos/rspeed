# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rspeed/version'

Gem::Specification.new do |spec|
  spec.author      = 'Washington Botelho'
  spec.description = ''
  spec.email       = 'wbotelhos@gmail.com'
  spec.files       = Dir['lib/**/*'] + %w[CHANGELOG.md LICENSE README.md]
  spec.homepage    = 'https://github.com/wbotelhos/rspeed'
  spec.license     = 'MIT'
  spec.name        = 'rspeed'
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = ''
  spec.test_files  = Dir['spec/**/*']
  spec.version     = RSpeed::VERSION

  spec.add_dependency 'rails', '>= 4.1', '< 6'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'sqlite3'
end
