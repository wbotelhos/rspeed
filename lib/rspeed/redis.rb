# frozen_string_literal: true

module RSpeed
  module Redis
    require 'redis'

    module_function

    def clean
      RSpeed::Logger.log(self, __method__, 'Cleaning pipes and profiles.')

      destroy(pattern: RSpeed::Variable::PIPES_PATTERN)
      destroy(pattern: RSpeed::Variable::PROFILE_PATTERN)
    end

    def client
      @client ||= ::Redis.new(db: RSpeed::Env.db, host: RSpeed::Env.host, port: RSpeed::Env.port)
    end

    def destroy(pattern:)
      RSpeed::Logger.log(self, __method__, %(Destroying pattern "#{pattern}".))

      keys(pattern: pattern).each { |key| client.del(key) }
    end

    def get(key)
      client.get(key)
    end

    def keys(pattern:)
      cursor = 0
      result = []

      loop do
        cursor, results = client.scan(cursor, match: pattern)
        result += results

        break if cursor.to_i.zero?
      end

      result
    end

    def list(key)
      client.lrange(key, 0, -1)
    end

    def profiles_content(pattern: 'rspeed:profile_*')
      client.keys(pattern).map { |key| list(key) }.flatten
    end

    def result?
      keys(pattern: RSpeed::Variable.result).any?
    end

    def set(key, value)
      client.set(key, value)
    end

    def specs_finished?
      (RSpeed::Redis.keys(pattern: RSpeed::Variable::PIPES_PATTERN).size == RSpeed::Env.pipes).tap do |boo|
        RSpeed::Logger.log(self, __method__, "Specs #{boo ? 'finished.' : 'not fineshed yet.'}")
      end
    end

    def specs_initiated?
      RSpeed::Redis.keys(pattern: RSpeed::Variable::PIPES_PATTERN).any?.tap do |boo|
        RSpeed::Logger.log(self, __method__, "Specs #{boo ? 'initialized.' : 'not initialized yet.'}")
      end
    end
  end
end
