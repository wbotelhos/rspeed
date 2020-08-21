# frozen_string_literal: true

module RSpeed
  class Splitter
    DEFAULT_PATTERN = 'rspeed_*'

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

            examples
          end
        end
      end
    end

    def append(files = CSV.read('rspeed.csv'))
      files.each do |time, file|
        redis.lpush('rspeed_tmp', { file: file, time: time.to_f }.to_json)
      end
    end

    def destroy(pattern = DEFAULT_PATTERN)
      keys(pattern).each { |key| redis.del key }
    end

    def diff
      actual_data + added_data
    end

    def first_pipe?
      pipe == 1
    end

    def get(pattern)
      @get ||= begin
        return redis.lrange(pattern, 0, -1) if %w[rspeed rspeed_tmp].include?(pattern)

        keys(pattern).map { |key| JSON.parse(redis.get(key)) }
      end
    end

    def keys(pattern = DEFAULT_PATTERN)
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

    def pipes
      result? ? ENV.fetch('RSPEED_PIPES') { 1 }.to_i : 1
    end

    def rename
      redis.rename('rspeed_tmp', 'rspeed')
    end

    def result?
      !keys('rspeed').empty?
    end

    def save(data = diff)
      split(data).each { |key, value| redis.set(key, value.to_json) }
    end

    def split(data)
      json = {}

      pipes.times do |index|
        json["rspeed_#{index + 1}".to_sym] ||= []
        json["rspeed_#{index + 1}".to_sym] = { total: 0, files: [], number: index + 1 }
      end

      sorted_data = data.sort_by { |item| item[:time] }.reverse

      sorted_data.each do |record|
        selected_pipe_data = json.min_by { |pipe| pipe[1][:total] }
        selected_pipe      = json["rspeed_#{selected_pipe_data[1][:number]}".to_sym]
        time               = record[:time].to_f

        selected_pipe[:total] += time
        selected_pipe[:files] << { file: record[:file], time: time }
      end

      json
    end

    private

    def actual_data
      rspeed_data.select { |item| actual_examples.include?(item[:file]) }
    end

    def added_data
      added_specs.map { |item| { file: item, time: 0 } }
    end

    def added_specs
      actual_examples - old_examples
    end

    def old_examples
      rspeed_data.map { |item| item[:file] }
    end

    def redis
      @redis ||= ::Redis.new(db: ENV['RSPEED_DB'], host: ENV['RSPEED_HOST'], port: ENV.fetch('RSPEED_PORT') { 6379 })
    end

    def removed_examples
      old_examples - actual_examples
    end

    def removed_time
      removed_examples.map { |item| item[0].to_f }.sum
    end

    def rspeed_data
      @rspeed_data ||= get('rspeed').map { |item| JSON.parse(item, symbolize_names: true) }
    end
  end
end
