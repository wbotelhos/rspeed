# frozen_string_literal: true

module RSpeed
  class Splitter
    DEFAULT_PATTERN = 'rspeed_*'

    def diff
      (actual_files + added_files).sort_by { |item| item[0].to_f }
    end

    def get(pattern = nil)
      @get ||= keys(pattern || DEFAULT_PATTERN).map { |key| JSON.parse redis.get(key) }
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

    def pipe
      ENV.fetch('RSPEED_PIPE') { 1 }.to_i
    end

    def pipes
      keys('rspeed').empty? ? 1 : ENV.fetch('RSPEED_PIPES') { 1 }.to_i
    end

    def save
      split.each do |key, value|
        redis.set key, value.to_json
      end
    end

    def split
      json = {}

      pipes.times do |index|
        json["rspeed_#{index + 1}".to_sym] ||= []
        json["rspeed_#{index + 1}".to_sym] = { total: 0, files: [], number: index + 1 }
      end

      data.each.with_index do |(time, file), _index|
        selected_pipe_data = json.min_by { |pipe| pipe[1][:total] }
        selected_pipe      = json["rspeed_#{selected_pipe_data[1][:number]}".to_sym]

        selected_pipe[:total] += time.to_f
        selected_pipe[:files] << [time, file]
      end

      json
    end

    private

    def actual_files
      saved_files.select { |item| actual_specs.include?(item[1]) }
    end

    def actual_specs
      Dir['./spec/**/*_spec.rb']
    end

    def added_files
      added_specs.map { |item| ['0.0', item] }
    end

    def added_specs
      actual_specs - saved_specs
    end

    def data
      CSV.read('rspeed.csv')
    end

    def redis
      @redis ||= ::Redis.new(db: 14, host: 'localhost', port: 6379)
    end

    def removed_specs
      saved_specs - actual_specs
    end

    def removed_time
      removed_specs.map { |item| item[0].to_f }.sum
    end

    def saved_specs
      saved_files.map { |file| file[1] }
    end

    def saved_files
      get.map { |item| item['files'] }.flatten(1)
    end
  end
end
