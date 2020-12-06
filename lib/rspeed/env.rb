# frozen_string_literal: true

module RSpeed
  module Env
    module_function

    def db
      ENV['RSPEED_DB']&.to_i
    end

    def host
      ENV['RSPEED_HOST']
    end

    def name
      ENV['RSPEED_NAME']
    end

    def pipe
      ENV.fetch('RSPEED_PIPE', 1).to_i
    end

    def pipes
      RSpeed::Redis.result? ? ENV.fetch('RSPEED_PIPES', 1).to_i : 1
    end

    def port
      ENV['RSPEED_PORT']&.to_i
    end

    def result_key
      ENV.fetch('RESPEED_RESULT_KEY', RSpeed::Variable.result)
    end

    def rspeed
      ENV['RSPEED'] == 'true'
    end

    def tmp_key
      ENV.fetch('RESPEED_TMP_KEY', RSpeed::Variable.tmp)
    end
  end
end
