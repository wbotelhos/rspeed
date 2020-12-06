# frozen_string_literal: true

module RSpeed
  module Redis
    require 'redis'

    module_function

    def clean_pipes_flag
      destroy(RSpeed::Variable::PIPES_PATTERN)
    end

    def client
      @client ||= ::Redis.new(db: RSpeed::Env.db, host: RSpeed::Env.host, port: RSpeed::Env.port)
    end

    def destroy(pattern = RSpeed::Variable::DEFAULT_PATTERN)
      keys(pattern).each { |key| client.del(key) }
    end

    def get(key)
      client.get(key)
    end

    def keys(pattern = RSpeed::Variable::DEFAULT_PATTERN)
      cursor = 0
      result = []

      loop do
        cursor, results = client.scan(cursor, match: pattern)
        result += results

        break if cursor.to_i.zero?
      end

      result
    end

    def result?
      keys(RSpeed::Env.result_key).any?
    end

    def set(key, value)
      client.set(key, value)
    end

    def specs_finished?
      RSpeed::Redis.keys(RSpeed::Variable::PIPES_PATTERN).size == RSpeed::Env.pipes
    end

    def specs_initiated?
      RSpeed::Redis.keys(RSpeed::Variable::PIPES_PATTERN).any?
    end
  end
end
