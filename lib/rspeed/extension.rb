# frozen_string_literal: true

if ENV['RSPEED'] == 'true'
  require 'rspec/rails'

  RSpec.configure do |config|
    config.before(:suite) { RSpeed::Observer.before_suite }
    config.before { |example| RSpeed::Observer.before(example) }
    config.after { |example| RSpeed::Observer.after(example) }
    config.after(:suite) { |example| RSpeed::Observer.after_suite }
  end
end
