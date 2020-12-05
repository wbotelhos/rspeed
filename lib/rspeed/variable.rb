# frozen_string_literal: true

module RSpeed
  module Variable
    module_function

    CSV             = 'rspeed.csv'
    DEFAULT_PATTERN = 'rspeed_*'
    PIPES_PATTERN   = 'rspeed_pipe_*'

    def append_name(value, suffix = nil)
      [value, RSpeed::Env.name, suffix].compact.join('_')
    end

    def key(number)
      append_name('rspeed', number).to_sym
    end

    def result
      append_name('rspeed')
    end

    def tmp
      append_name('rspeed_tmp')
    end

    def pipe_name
      append_name('rspeed_pipe', RSpeed::Env.pipe)
    end
  end
end
