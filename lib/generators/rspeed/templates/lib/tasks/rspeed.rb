# frozen_string_literal: true

require 'rspeed'

namespace :rspeed do
  task run: :environment do
    ::RSpeed::Runner.run ->(command) { sh command }
  end
end
