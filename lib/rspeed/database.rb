# frozen_string_literal: true

module RSpeed
  module Database
    module_function

    def previous_result
      list(RSpeed::Variable.previous_result)
    end

    def result
      list(RSpeed::Variable.result)
    end

    def list(key)
      RSpeed::Redis.list(key).map { |item| JSON.parse(item, symbolize_names: true) }
    end
  end
end
