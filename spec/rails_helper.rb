# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'fakeredis/rspec'
require 'json'
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

def redis_object
  @redis_object ||= Redis.new(db: ENV['RSPEED_DB'], host: ENV['RSPEED_HOST'])
end
