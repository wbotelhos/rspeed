# frozen_string_literal: true

module RSpeed
  module Redis
    require 'redis'

    module_function

    def client
      @client ||= ::Redis.new(db: RSpeed::Env.db, host: RSpeed::Env.host, port: RSpeed::Env.port)
    end

    def get(key)
      client.get(key)
    end

    def set(key, value)
      client.set(key, value)
    end
  end
end
