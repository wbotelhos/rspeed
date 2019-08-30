# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'fakeredis/rspec'
require 'pry-byebug'
require 'rspec'
require 'rspeed'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.order = :random

  config.after do
    ENV.delete 'RSPEED_PIPE'
    ENV.delete 'RSPEED_PIPES'
  end
end
