# frozen_string_literal: true

module RSpeed
  module Variable
    module_function

    DEFAULT_PATTERN = 'rspeed_*'
    CSV             = 'rspeed.csv'

    def key(number)
      "rspeed_#{number}".to_sym
    end

    def result
      'rspeed'
    end

    def tmp
      'rspeed_tmp'
    end
  end
end
