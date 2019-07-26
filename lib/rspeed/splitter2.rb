# frozen_string_literal: true

module RSpeed
  class Splitter
    DEFAULT_PATTERN = 'rspeed_*'

    def destroy_result
      redis.del 'rspeeds'
    end

    def rename
      keys.each do |key|
        redis.del key
      end

      result = redis.lrange('rspeeds', 0, -1)

      total = 0
      data  = { total: 0, files: [], number: 0 }

      result.each do |item|
        json = JSON.parse(item)

        total += json['time'].to_f

        data[:files] << [json['time'], json['file']]
      end

      data[:total] = total

      redis.set 'rspeed_0', data.to_json

      destroy_result
    end

    def append_result(json, key = 'rspeeds')
      json.each do |file, time|
        redis.lpush key, { file: file, time: time }.to_json
      end
    end

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

    # TODO: spec
    def runner_files
      pipe_number  = ENV.fetch('RSPEED_PIPE', 1).to_i
      pipes_number = ENV.fetch('RSPEED_PIPES', 1).to_i
      splitter     = ::RSpeed::Splitter.new

      if pipe_number == 1
        binding.pry; p 'debugging...'

        save pipes_number, JSON.parse(redis.get('rspeed_0'))
      end

      binding.pry; p 'debugging...'

      json        = splitter.get("rspeed_#{pipe_number}")
      files_data  = json.map { |item| item['files'] }.reject(&:blank?).flatten(1)
      files       = files_data.map { |item| item[1] }

      binding.pry; p 'debugging...'

      if files.empty?
        puts "\n\n>>> [RSpeed] Pipe #{pipe_number}: no specs to run."

        []
      else
        puts "\n\n>>> [RSpeed] Pipe #{pipe_number}:\n\n#{files.join("\n")}\n\n"

        files.join(' ')
      end
    end

    def save(number_of_pipes, source = nil)
      split number_of_pipes, source

      @pipes.each do |key, value|
        redis.set key, value.to_json
      end
    end

    def split(number_of_pipes, source)
      @pipes = {}

      number_of_pipes.times do |index|
        @pipes["rspeed_#{index + 1}".to_sym] ||= []
        @pipes["rspeed_#{index + 1}".to_sym] = { total: 0, files: [], number: index + 1 }
      end

      data(source).each.with_index do |(time, file), _index|
        selected_pipe_data = @pipes.min_by { |pipe| pipe[1][:total] }
        selected_pipe      = @pipes["rspeed_#{selected_pipe_data[1][:number]}".to_sym]

        selected_pipe[:total] += time.to_f
        selected_pipe[:files] << [time, file]
      end

      @pipes
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

    def data(source)
      return source if source # TODO: spec

      CSV.read 'rspeed.csv'
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
