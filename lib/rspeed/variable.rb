# frozen_string_literal: true

module RSpeed
  module Variable
    module_function

    DEFAULT_PATTERN = 'rspeed_*'
    CSV             = 'rspeed.csv'

    def key(number)
      [append_name('rspeed'), number].join('_').to_sym
    end

    def result
      append_name('rspeed')
    end

    def tmp
      append_name('rspeed_tmp')
    end

    def name
      'rspeed_name'
    end

    def append_name(value)
      [value, RSpeed::Env.name].flatten.compact.join('_')
    end
  end
end
