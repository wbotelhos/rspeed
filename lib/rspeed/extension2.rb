# frozen_string_literal: true

if ENV['RSPEED'] == 'true'
  RSpec.configure do |config|
    config.before :suite do
      File.open('rspeed.csv', 'w') { |file| file.truncate 0 }
    end

    config.before do |example|
      file_path = example.metadata[:file_path]
      start_at  = example.clock.now

      puts %([RSpeed:before] #{file_path} started at: #{start_at})

      example.update_inherited_metadata start_at: start_at
    end

    config.after do |example|
      file_path       = example.metadata[:file_path]
      time_difference = example.clock.now - example.metadata[:start_at]

      puts %([RSpeed:after] #{file_path} took: #{time_difference}\n\n)

      File.open('rspeed.csv', 'a') do |file|
        file.write "#{time_difference},#{file_path}\n"
      end
    end

    config.after :suite do |_example|
      puts "\n\n>>> [RSpeed] Statistics:\n\n"

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

      result.each do |file, time|
        puts "#{time},#{file}\n"
      end

      puts "\n\n>>> [RSpeed] Result:\n\n"

      splitter     = ::RSpeed::Splitter.new
      rspeed_pipe  = ENV.fetch('RSPEED_PIPE', 1).to_i
      rspeed_pipes = splitter.keys.empty? ? 1 : ENV.fetch('RSPEED_PIPES', 1).to_i

      binding.pry; p 'debugging...'

      if rspeed_pipe == 1
        splitter.destroy_result
      end

      if splitter.keys.empty?
        puts splitter.save 1
      else
        puts splitter.save rspeed_pipes
      end

      splitter.append_result result

      if rspeed_pipes == rspeed_pipe
        splitter.rename
      end
    end
  end
end