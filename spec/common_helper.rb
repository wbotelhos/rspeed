# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'support/coverage'

require 'pry-byebug'
require 'rspeed'
require 'support/common'
require 'support/fakeredis'
