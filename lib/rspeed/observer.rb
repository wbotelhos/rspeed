# frozen_string_literal: true

module RSpeed
  module Observer
    module_function

    def after(example)
      file_path   = example.metadata[:file_path]
      line_number = example.metadata[:line_number]
      spent_time  = example.clock.now - example.metadata[:start_at]

      File.open('rspeed.csv', 'a') do |file|
        file.write "#{spent_time},#{file_path}:#{line_number}\n"
      end
    end

    def after_suite
      result = {}

      CSV.read('rspeed.csv').each do |row|
        spent_time = row[0]
        file_path  = row[1]

        result[file_path] ||= 0
        result[file_path] += spent_time.to_f
      end

      result = result.sort_by { |row| row[1] }.reverse

      truncate_csv_file

      File.open('rspeed.csv', 'a') do |file|
        result.each { |file_path, spent_time| file.write("#{spent_time},#{file_path}\n") }
      end
    end

    def before(example)
      example.update_inherited_metadata(start_at: example.clock.now)
    end

    def before_suite
      truncate_csv_file
    end

    def truncate_csv_file
      File.open('rspeed.csv', 'w') { |file| file.truncate(0) }
    end
  end
end
