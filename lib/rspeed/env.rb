# frozen_string_literal: true

module RSpeed
  module Env
    module_function

    def name
      ENV['RSPEED_NAME']
    end

    def pipe
      ENV.fetch('RSPEED_PIPE') { 1 }.to_i
    end

    def pipes(has_result)
      has_result ? ENV.fetch('RSPEED_PIPES') { 1 }.to_i : 1
    end

    def result_key
      ENV.fetch('RESPEED_RESULT_KEY', RSpeed::Variable.result)
    end

    def tmp_key
      ENV.fetch('RESPEED_TMP_KEY', RSpeed::Variable.tmp)
    end
  end
end
