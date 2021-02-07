# frozen_string_literal: true

module RSpeed
  module Variable
    module_function

    PIPES_PATTERN   = 'rspeed:pipe_*'
    PROFILE_PATTERN = 'rspeed:profile_*'

    def append_app_name(value, plus: nil)
      [value, RSpeed::Env.app, plus].compact.join('_')
    end

    def key(number)
      append_app_name('rspeed', plus: number).to_sym
    end

    def result
      append_app_name('rspeed')
    end

    def pipe
      append_app_name('rspeed:pipe', plus: format('%02d', RSpeed::Env.pipe))
    end

    def profile
      append_app_name('rspeed:profile', plus: format('%02d', RSpeed::Env.pipe))
    end
  end
end
