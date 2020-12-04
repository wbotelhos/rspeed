# frozen_string_literal: true

module RSpeed
  class Splitter
    def initialize(specs_path: './spec/**/*_spec.rb')
      @specs_path = specs_path
    end

    def actual_examples
      @actual_examples ||= begin
        [].tap do |examples|
          Dir[@specs_path].each do |file|
            data     = File.open(file).read
            lines    = data.split("\n")

            lines&.each.with_index do |item, index|
              examples << "#{file}:#{index + 1}" if item.gsub(/\s+/, '') =~ /^it/
            end
          end

          stream(:actual_examples, examples)
        end
      end
    end

    def append(files = CSV.read(RSpeed::Variable::CSV))
      files.each do |time, file|
        redis.lpush(tmp_key, { file: file, time: time.to_f }.to_json)
      end
    end

    def destroy(pattern = RSpeed::Variable::DEFAULT_PATTERN)
      keys(pattern).each { |key| redis.del(key) }
    end

    def diff
      actual_data = rspeed_data.select { |item| actual_examples.include?(item[:file]) }
      added_data  = added_examples.map { |item| { file: item, time: 0 } }

      removed_examples # called just for stream for now

      actual_data + added_data
    end

    def first_pipe?
      pipe == 1
    end

    def get(pattern)
      @get ||= begin
        return redis.lrange(pattern, 0, -1) if [RSpeed::Variable.result, RSpeed::Variable.tmp].include?(pattern)

        keys(pattern).map { |key| JSON.parse(redis.get(key)) }
      end
    end

    def keys(pattern = RSpeed::Variable::DEFAULT_PATTERN)
      cursor = 0
      result = []

      loop do
        cursor, results = redis.scan(cursor, match: pattern)
        result += results

        break if cursor.to_i.zero?
      end

      result
    end

    def last_pipe?
      pipe == pipes
    end

    def pipe
      ENV.fetch('RSPEED_PIPE') { 1 }.to_i
    end

    def pipe_files
      return unless result?

      split[RSpeed::Variable.key(pipe)][:files].map { |item| item[:file] }.join(' ')
    end

    def pipes
      result? ? ENV.fetch('RSPEED_PIPES') { 1 }.to_i : 1
    end

    def redundant_run?
      !first_pipe? && !exists?(result_key)
    end

    def rename
      redis.rename(tmp_key, result_key)
    end

    def result?
      !keys(result_key).empty?
    end

    def result_key
      ENV.fetch('RESPEED_RESULT_KEY', RSpeed::Variable.result)
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

    def tmp_key
      ENV.fetch('RESPEED_TMP_KEY', RSpeed::Variable.tmp)
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
      @redis ||= ::Redis.new(db: ENV['RSPEED_DB'], host: ENV['RSPEED_HOST'], port: ENV.fetch('RSPEED_PORT') { 6379 })
    end

    def removed_examples
      @removed_examples ||= begin
        (rspeed_examples - actual_examples).tap { |examples| stream(:removed_examples, examples) }
      end
    end

    def removed_time
      removed_examples.map { |item| item[0].to_f }.sum
    end

    def rspeed_data
      @rspeed_data ||= get(result_key).map { |item| JSON.parse(item, symbolize_names: true) }
    end

    def rspeed_examples
      rspeed_data.map { |item| item[:file] }
    end

    def stream(type, data)
      puts "PIPE: #{pipe} with #{type}: #{data}"
    end
  end
end
