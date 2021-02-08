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

        RSpeed::Logger.log(self, __method__, data)
      end
    end

    def actual_data(files:, result:)
      result
        .select { |item| files.include?(item[:file]) }
        .tap { |data| RSpeed::Logger.log(self, __method__, data) }
    end

    def added_data(files:, result:)
      (files - result.map { |item| item[:file] })
        .map { |file| { file: file, time: 0 } }
        .tap { |data| RSpeed::Logger.log(self, __method__, data) }
    end

    def diff
      files  = actual_files
      result = RSpeed::Database.result.uniq { |item| item[:file] }
      actual = actual_data(files: files, result: result) + added_data(files: files, result: result)

      {
        actual:  actual.tap { |data| RSpeed::Logger.log(self, __method__, data) },
        added:  '--',
        removed: removed_data(files: files, result: result),
      }
    end

    def removed_data(files:, result:)
      result
        .reject { |item| files.include?(item[:file]) }
        .tap { |data| RSpeed::Logger.log(self, __method__, data) }
    end

    def removed_time(data:)
      data
        .sum { |item| item[:time].to_f }
        .tap { |result| RSpeed::Logger.log(self, __method__, result) }
    end
  end
end
