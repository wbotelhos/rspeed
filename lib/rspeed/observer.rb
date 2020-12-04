# frozen_string_literal: true

module RSpeed
  module Observer
    module_function

    def after(example)
      file_path   = example.metadata[:file_path]
      line_number = example.metadata[:line_number]
      spent_time  = example.clock.now - example.metadata[:start_at]

      File.open(RSpeed::Variable::CSV, 'a') do |file|
        file.write("#{spent_time},#{file_path}:#{line_number}\n")
      end
    end

    def before(example)
      example.update_inherited_metadata(start_at: example.clock.now)
    end

    def before_suite
      truncate_csv_file
    end

    def truncate_csv_file
      File.open(RSpeed::Variable::CSV, 'w') { |file| file.truncate(0) }
    end
  end
end
