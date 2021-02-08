# frozen_string_literal: true

module RSpeed
  module Splitter
    module_function

    require 'json'

    require 'rspeed/differ'

    def append(items:, key:)
      items.each { |item| RSpeed::Redis.client.rpush(key, item) }
    end

    def consolidate
      RSpeed::Logger.log(self, __method__, 'Consolidating profiles.')

      RSpeed::Redis.destroy(pattern: RSpeed::Variable.result)

      append(items: RSpeed::Redis.profiles_content, key: RSpeed::Variable.result)
    end

    def first_pipe?
      RSpeed::Env.pipe == 1
    end

    def need_warm?
      first_pipe? && !RSpeed::Redis.result?
    end

    def pipe_files
      return unless RSpeed::Redis.result?

      splitted = split(data: RSpeed::Differ.diff[:actual_files])

      splitted[RSpeed::Variable.key(RSpeed::Env.pipe)][:files].tap do |items|
        RSpeed::Reporter.print_files(items)
      end.map { |item| item[:file] }.join(' ')
    end

    def split(data:)
      json = {}

      RSpeed::Env.pipes.times do |index|
        json[RSpeed::Variable.key(index + 1)] ||= []
        json[RSpeed::Variable.key(index + 1)] = { total: 0, files: [], number: index + 1 }
      end

      sorted_data = data.sort_by { |item| item[:time] || 0.0 }.reverse

      sorted_data.each do |record|
        selected_pipe_data = json.min_by { |pipe| pipe[1][:total] }
        selected_pipe      = json[RSpeed::Variable.key(selected_pipe_data[1][:number])]
        time               = record[:time].to_f

        selected_pipe[:total] += time
        selected_pipe[:files] << { file: record[:file], time: time }
      end

      json
    end
  end
end
