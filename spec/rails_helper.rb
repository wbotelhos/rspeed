# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'pry-byebug'
require 'rspeed'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }
