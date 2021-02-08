# frozen_string_literal: true

require_relative 'lib/rspeed/version'

Gem::Specification.new do |spec|
  spec.author           = 'Washington Botelho'
  spec.description      = 'Split and speed up your RSpec tests.'
  spec.email            = 'wbotelhos@gmail.com'
  spec.extra_rdoc_files = Dir['CHANGELOG.md', 'LICENSE', 'README.md']
  spec.files            = `git ls-files lib`.split("\n")
  spec.homepage         = 'https://github.com/wbotelhos/rspeed'
  spec.license          = 'MIT'
  spec.name             = 'rspeed'
  spec.summary          = 'Split and speed up your RSpec tests.'
  spec.test_files       = Dir['spec/**/*']
  spec.version          = RSpeed::VERSION

  spec.add_dependency 'redis'
  spec.add_dependency 'rspec'
  spec.add_dependency 'terminal-table'

  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'env_mock'
  spec.add_development_dependency 'fakeredis'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'rubocop-rspec'
end
