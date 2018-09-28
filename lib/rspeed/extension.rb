# frozen_string_literal: true

if ENV['RSPEED'] == 'true'
  require 'csv'

  RSpec.configure do |config|
    config.before :suite do
      number_of_threads = 3

      File.open('rspeed.csv.tmp', 'w') { |file| file.truncate 0 }
    end

    config.before do |example|
      file_path = example.metadata[:file_path]
      start_at  = example.clock.now

      puts %([RSpeed:before] Test #{file_path} started at: #{start_at})

      example.update_inherited_metadata start_at: start_at
    end

    config.after do |example|
      file_path       = example.metadata[:file_path]
      time_difference = example.clock.now - example.metadata[:start_at]

      puts %([RSpeed:after] Test #{file_path} took: #{time_difference}\n\n)

      File.open('rspeed.csv.tmp', 'a') do |file|
        file.write "#{time_difference},#{file_path}\n"
      end
    end

    config.after :suite do |_example|
      puts "\n\n>>> [RSpeed] Result:\n\n"

      result = {}

      CSV.read('rspeed.csv.tmp').each do |line|
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

      # mapped_specs = result.keys
      # specs        = Dir['./spec/**/*_spec.rb']
      # new_specs    = specs.reject { |spec| mapped_specs.include? spec }
      #
      # new_specs.each do |new_spec|
      #   result[new_spec] = 0
      # end

      result.each do |file, time|
        puts "#{time},#{file}\n"
      end
    end
  end
end
