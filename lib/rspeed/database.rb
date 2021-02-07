# frozen_string_literal: true

module RSpeed
  module Database
    module_function

    def result
      RSpeed::Redis.list(RSpeed::Variable.result).map { |item| JSON.parse(item, symbolize_names: true) }
    end
  end
end
