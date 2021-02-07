# frozen_string_literal: true

module RSpeed
  module Differ
    module_function

    def actual_files(spec_path: RSpeed::Env.spec_path)
      [].tap do |examples|
        Dir[spec_path].sort.each do |file|
          data     = File.open(file).read
          lines    = data.split("\n")

          lines&.each&.with_index do |item, index|
            examples << "#{file}:#{index + 1}" if /^it/.match?(item.gsub(/\s+/, ''))
          end
        end

        stream(:actual_files, examples)
      end
    end

    def actual_data(files:, result:)
      result
        .select { |item| files.include?(item[:file]) }
        .tap { |data| stream(:actual_data, data) }
    end

    def added_data(files:, result:)
      (files - result.map { |item| item[:file] })
        .map { |file| { file: file, time: 0 } }
        .tap { |examples| stream(:added, examples) }
    end

    def diff
      files  = actual_files
      result = RSpeed::Database.result

      removed_data(files: files, result: result) # called just for stream purpose

      actual_data(files: files, result: result) + added_data(files: files, result: result)
    end

    def removed_data(files:, result:)
      result
        .reject { |item| files.include?(item[:file]) }
        .tap { |data| stream(:removed, data) }
    end

    def removed_time(data:)
      data.sum { |item| item[:time].to_f }
    end

    def stream(type, data)
      RSpeed::Logger.log("PIPE: #{RSpeed::Env.pipe} with #{type}: #{data}")
    end
  end
end
