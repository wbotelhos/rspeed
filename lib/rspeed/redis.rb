# frozen_string_literal: true

module RSpeed
  module Redis
    require 'redis'

    module_function

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

    def set(key, value)
      client.set(key, value)
    end
  end
end
