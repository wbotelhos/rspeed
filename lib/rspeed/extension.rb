# frozen_string_literal: true

if RSpeed::Env.rspeed
  require 'rspec'

  RSpec.configure do |config|
    config.before(:suite) { RSpeed::Observer.before_suite }
    config.before { |example| RSpeed::Observer.before(example) }
    config.after { |example| RSpeed::Observer.after(example) }
  end
end
