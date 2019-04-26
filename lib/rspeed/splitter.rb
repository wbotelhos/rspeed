# frozen_string_literal: true

class Splitter
  def keys(key = 'rspeed_*')
    cursor = 0
    result = []

    loop do
      cursor, results = redis.scan(cursor, match: key)
      result += results

      break if cursor.to_i.zero?
    end

    result
  end

  def save(number_of_pipes)
    split number_of_pipes

    @pipes.each do |key, value|
      redis.set key, value.to_json
    end
  end

  def split(number_of_pipes)
    @pipes = {}

    number_of_pipes.times do |index|
      @pipes["rspeed_#{index}".to_sym] ||= []
      @pipes["rspeed_#{index}".to_sym] = { total: 0, files: [], number: index }
    end

    data.each.with_index do |(time, file), _index|
      selected_pipe_data = @pipes.min_by { |pipe| pipe[1][:total] }
      selected_pipe      = @pipes["rspeed_#{selected_pipe_data[1][:number]}".to_sym]

      selected_pipe[:total] += time
      selected_pipe[:files] << [time, file]
    end

    @pipes
  end

  private

  def data
    @data ||= [
      [2.0, '2_0_spec.rb'],
      [1.5, '1_5_spec.rb'],
      [1.1, '1_1_spec.rb'],
      [0.7, '0_7_spec.rb'],
      [0.4, '0_4_spec.rb'],
      [0.3, '0_3_spec.rb'],
      [0.2, '0_2_spec.rb']
    ]
  end

  def redis
    @redis ||= Redis.new(db: 14, host: 'localhost', port: 6379)
  end
end
