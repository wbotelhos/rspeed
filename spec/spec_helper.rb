# frozen_string_literal: true

def delete_file(file_path = 'rspeed.csv')
  File.delete(file_path) if File.exist?(file_path)
end

def truncate_file(file_path = 'rspeed.csv')
  File.open(file_path, 'w') { |file| file.truncate(0) }
end

def populate_csv_file
  data = [
    '2.0,./spec/2_0_spec.rb',
    '1.5,./spec/1_5_spec.rb',
    '1.1,./spec/1_1_spec.rb',
    '0.7,./spec/0_7_spec.rb',
    '0.4,./spec/0_4_spec.rb',
    '0.3,./spec/0_3_spec.rb',
    '0.2,./spec/0_2_spec.rb',
  ].join("\n")

  File.open('rspeed.csv', 'a') { |file| file.write(data) }
end

def redis_object
  @redis_object ||= Redis.new(db: ENV['RSPEED_DB'], host: ENV['RSPEED_HOST'])
end
