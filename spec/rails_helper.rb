# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'fakeredis/rspec'
require 'pry-byebug'
require 'rspec'
require 'rspeed'

RSpec.configure do |config|
  config.filter_run_when_matching :focus

  config.disable_monkey_patching!

  config.order = :random
end
