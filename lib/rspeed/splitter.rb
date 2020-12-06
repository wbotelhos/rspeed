# frozen_string_literal: true

module RSpeed
  class Splitter
    require 'json'

    def initialize(specs_path: './spec/**/*_spec.rb')
      @specs_path = specs_path
    end

    def actual_examples
      @actual_examples ||= begin
        [].tap do |examples|
          Dir[@specs_path].sort.each do |file|
            data     = File.open(file).read
            lines    = data.split("\n")

            lines&.each&.with_index do |item, index|
              examples << "#{file}:#{index + 1}" if /^it/.match?(item.gsub(/\s+/, ''))
            end
          end

          stream(:actual_examples, examples)
        end
      end
    end

    def append(files = CSV.read(RSpeed::Variable::CSV))
      files.each do |time, file|
        redis.lpush(RSpeed::Env.tmp_key, { file: file, time: time.to_f }.to_json)
      end
    end

    def diff
      actual_data = rspeed_data.select { |item| actual_examples.include?(item[:file]) }
      added_data  = added_examples.map { |item| { file: item, time: 0 } }

      removed_examples # called just for stream for now

      actual_data + added_data
    end

    def first_pipe?
      RSpeed::Env.pipe == 1
    end

    def get(pattern)
      @get ||= begin
        return redis.lrange(pattern, 0, -1) if [RSpeed::Variable.result, RSpeed::Variable.tmp].include?(pattern)

        RSpeed::Redis.keys(pattern).map { |key| ::JSON.parse(redis.get(key)) }
      end
    end

    def last_pipe?
      RSpeed::Env.pipe == pipes
    end

    def pipe_files
      return unless RSpeed::Redis.result?

      split[RSpeed::Variable.key(RSpeed::Env.pipe)][:files].map { |item| item[:file] }.join(' ')
    end

    def pipes
      RSpeed::Env.pipes(RSpeed::Redis.result?)
    end

    def redundant_run?
      !first_pipe? && !exists?(RSpeed::Env.result_key)
    end

    def rename
      redis.rename(RSpeed::Env.tmp_key, RSpeed::Env.result_key)
    end

    def split(data = diff)
      json = {}

      pipes.times do |index|
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

    private

    def added_examples
      @added_examples ||= begin
        (actual_examples - rspeed_examples).tap { |examples| stream(:added_examples, examples) }
      end
    end

    # TODO: exists? does not work: undefined method `>' for false:FalseClass
    def exists?(key)
      redis.keys.include?(key)
    end

    def redis
      @redis ||= ::RSpeed::Redis.client
    end

    def removed_examples
      @removed_examples ||= begin
        (rspeed_examples - actual_examples).tap { |examples| stream(:removed_examples, examples) }
      end
    end

    def removed_time
      removed_examples.sum { |item| item[0].to_f }
    end

    def rspeed_data
      @rspeed_data ||= get(RSpeed::Env.result_key).map { |item| JSON.parse(item, symbolize_names: true) }
    end

    def rspeed_examples
      rspeed_data.map { |item| item[:file] }
    end

    def stream(type, data)
      puts "PIPE: #{RSpeed::Env.pipe} with #{type}: #{data}"
    end
  end
end
