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
      (files - result.map { |item| item[:file] }).map { |file| { file: file, time: nil } }
    end

    def diff(from: actual_files, to: RSpeed::Database.result)
      to      = to.uniq { |item| item[:file] }
      added   = added_data(files: from, result: to)
      actual  = actual_data(files: from, result: to) + added_data(files: from, result: to)
      removed = removed_data(files: from, result: to)

      {
        actual_files:  actual,
        actual_time:   sum_time(data: actual),
        added_files:   added,
        added_time:    sum_time(data: added),
        removed_files: removed,
        removed_time:  sum_time(data: removed),
      }
    end

    def final_diff(from: RSpeed::Database.previous_result, to: RSpeed::Database.result)
      from           = from.uniq { |item| item[:file] }
      to             = to.uniq { |item| item[:file] }
      previous_files = from.map { |item| item[:file] }
      actual_files   = to.map { |item| item[:file] }
      added          = to.reject { |item| previous_files.include?(item[:file]) }
      removed        = from.reject { |item| actual_files.include?(item[:file]) }

      {
        actual_files:  to,
        actual_time:   sum_time(data: to),
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
      return '?' if data.all? { |item| item[:time].nil? }

      data.sum { |item| item[:time].to_f }
    end
  end
end
