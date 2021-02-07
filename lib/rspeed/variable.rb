# frozen_string_literal: true

module RSpeed
  module Variable
    module_function

    DEFAULT_PATTERN = 'rspeed_*'
    PIPES_PATTERN   = 'rspeed_pipe_*'
    PROFILE_PATTERN = 'rspeed_profile_*'

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
      append_app_name('rspeed_pipe', plus: RSpeed::Env.pipe)
    end

    def profile
      append_app_name('rspeed_profile', plus: RSpeed::Env.pipe)
    end
  end
end
