# frozen_string_literal: true

module RSpeed
  module Splitter
    module_function

    require 'json'

    def actual_examples(spec_path: RSpeed::Env.spec_path)
      [].tap do |examples|
        Dir[spec_path].sort.each do |file|
          data     = File.open(file).read
          lines    = data.split("\n")

          lines&.each&.with_index do |item, index|
            examples << "#{file}:#{index + 1}" if /^it/.match?(item.gsub(/\s+/, ''))
          end
        end

        stream(:actual_examples, examples)
      end
    end

    def append(items:, key:)
      items.each { |item| RSpeed::Redis.client.rpush(key, item) }
    end

    def consolidate
      RSpeed::Logger.log('[RSpeed::Splitter#consolidate] Consolidating profiles.')

      RSpeed::Redis.destroy(RSpeed::Variable.result)

      append(items: RSpeed::Redis.profiles_content, key: RSpeed::Variable.result)
    end

    def consolidated_json
      RSpeed::Redis.list(RSpeed::Variable.result).map do |item|
        JSON.parse(item, symbolize_names: true)
      end
    end

    def diff
      consolidated_data  = consolidated_json
      consolidated_files = consolidated_data.map { |item| item[:file] }
      actual_files       = actual_examples

      removed_examples(actual: actual_files, consolidated: consolidated_files) # called just for stream for now

      actual_data = consolidated_data.select { |item| actual_files.include?(item[:file]) }

      added_data = added_examples(actual: actual_files, consolidated: consolidated_files).map do |item|
        { file: item, time: 0 }
      end

      actual_data + added_data
    end

    def first_pipe?
      RSpeed::Env.pipe == 1
    end

    def need_warm?
      first_pipe? && !RSpeed::Redis.result?
    end

    def pipe_files
      return unless RSpeed::Redis.result?

      split[RSpeed::Variable.key(RSpeed::Env.pipe)][:files].map { |item| item[:file] }.join(' ')
    end

    def split(data = diff)
      json = {}

      RSpeed::Env.pipes.times do |index|
        json[RSpeed::Variable.key(index + 1)] ||= []
        json[RSpeed::Variable.key(index + 1)] = { total: 0, files: [], number: index + 1 }
      end

      sorted_data = data.sort_by { |item| item[:time] }.reverse

      sorted_data.each do |record|
        selected_pipe_data = json.min_by { |pipe| pipe[1][:total] }
        selected_pipe      = json[RSpeed::Variable.key(selected_pipe_data[1][:number])]
        time               = record[:time].to_f

        selected_pipe[:total] += time
        selected_pipe[:files] << { file: record[:file], time: time }
      end

      json
    end

    # private

    def added_examples(actual:, consolidated:)
      (actual - consolidated).tap { |examples| stream(:added_examples, examples) }
    end


    def removed_examples(actual:, consolidated:)
      (consolidated - actual).tap { |examples| stream(:removed_examples, examples) }
    end

    # def removed_time(actual:, consolidated:)
    #   removed_examples((actual: actual, consolidated: consolidated)).sum { |item| item[0].to_f }
    # end

    def stream(type, data)
      RSpeed::Logger.log("PIPE: #{RSpeed::Env.pipe} with #{type}: #{data}")
    end
  end
end
