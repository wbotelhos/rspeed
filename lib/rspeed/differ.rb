# frozen_string_literal: true

module RSpeed
  module Differ
    module_function

    def actual_files(spec_path: RSpeed::Env.spec_path)
      [].tap do |data|
        Dir[spec_path].sort.each do |file|
          lines = File.open(file).read.split("\n")

          lines&.each&.with_index do |item, index|
            data << "#{file}:#{index + 1}" if /^it/.match?(item.gsub(/\s+/, ''))
          end
        end
      end
    end

    def actual_data(files:, result:)
      result.select { |item| files.include?(item[:file]) }
    end

    def added_data(files:, result:)
      (files - result.map { |item| item[:file] }).map { |file| { file: file, time: 0.0 } }
    end

    def diff
      files   = actual_files
      result  = RSpeed::Database.result.uniq { |item| item[:file] }
      added   = added_data(files: files, result: result)
      actual  = actual_data(files: files, result: result) + added_data(files: files, result: result)
      removed = removed_data(files: files, result: result)

      {
        actual_files:  actual,
        actual_time:   sum_time(data: actual),
        added_files:   added,
        added_time:    sum_time(data: added),
        removed_files: removed,
        removed_time:  sum_time(data: removed),
      }
    end

    def removed_data(files:, result:)
      result.reject { |item| files.include?(item[:file]) }
    end

    def sum_time(data:)
      data.sum { |item| item[:time].to_f }
    end
  end
end
