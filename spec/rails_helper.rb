# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'active_record/railtie'
require 'rspeed'
require 'pry-byebug'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }
