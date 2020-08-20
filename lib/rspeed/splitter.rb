# frozen_string_literal: true

module RSpeed
  class Splitter
    DEFAULT_PATTERN = 'rspeed_*'

    def append(files = file_data)
      files.each do |time, file|
        redis.lpush 'rspeed_tmp', { file: file, time: time.to_f }.to_json
      end
    end

    def destroy(pattern = DEFAULT_PATTERN)
      keys(pattern).each { |key| redis.del key }
    end

    def diff
      (actual_files + added_files).sort_by { |item| item[:time].to_f }.map do |item|
        [item[:time], item[:file]]
      end
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
      redis.rename 'rspeed_tmp', 'rspeed'
    end

    def result?
      !keys('rspeed').empty?
    end

    def save(data = rspeed_data)
      split(data).each do |key, value|
        redis.set key, value.to_json
      end
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

    def actual_files
      rspeed_data.select { |item| actual_specs.include?(item[:file]) }
    end

    def actual_specs
      Dir['./spec/**/*_spec.rb']
    end

    def added_files
      added_specs.map { |item| { file: item, time: 0 } }
    end

    def added_specs
      actual_specs - saved_specs
    end

    def file_data
      CSV.read('rspeed.csv')
    end

    def redis
      @redis ||= ::Redis.new(db: ENV['RSPEED_DB'], host: ENV['RSPEED_HOST'], port: ENV.fetch('RSPEED_PORT') { 6379 })
    end

    def removed_specs
      saved_specs - actual_specs
    end

    def removed_time
      removed_specs.map { |item| item[0].to_f }.sum
    end

    def rspeed_data
      get('rspeed').map { |item| JSON.parse(item, symbolize_names: true) }
    end

    def saved_specs
      rspeed_data.map { |item| item[:file] }
    end
  end
end
