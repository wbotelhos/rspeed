# frozen_string_literal: true

if ENV['RSPEED'] == 'true'
  require 'rspec/rails'

  RSpec.configure do |config|
    config.before :suite do
      File.open('rspeed.csv', 'w') { |file| file.truncate 0 }
    end

    config.before do |example|
      example.update_inherited_metadata start_at: example.clock.now
    end

    config.after do |example|
      file_path       = example.metadata[:file_path]
      time_difference = example.clock.now - example.metadata[:start_at]

      File.open('rspeed.csv', 'a') do |file|
        file.write "#{time_difference},#{file_path}\n"
      end
    end

    config.after :suite do |_example|
      result = {}

      CSV.read('rspeed.csv').each do |line|
        result[line[1]] ||= 0
        result[line[1]] += line[0].to_d
      end

      result = result.sort_by { |line| line[1] }.reverse

      File.open('rspeed.csv', 'w') { |file| file.truncate 0 }

      File.open('rspeed.csv', 'a') do |file|
        result.each do |file_spec, time|
          file.write "#{time},#{file_spec}\n"
        end
      end
    end
  end
end
