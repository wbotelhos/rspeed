# frozen_string_literal: true

module RSpeed
  module Observer
    module_function

    def after(example)
      file_path   = example.metadata[:file_path]
      line_number = example.metadata[:line_number]
      spent_time  = example.clock.now - example.metadata[:start_at]

      json = { file: "#{file_path}:#{line_number}", time: spent_time }.to_json

      RSpeed::Redis.client.lpush(RSpeed::Variable.profile, json)
    end

    def after_suite(splitter = ::RSpeed::Splitter.new)
      RSpeed::Redis.set(RSpeed::Variable.pipe_name, true)

      return unless RSpeed::Redis.specs_finished?

      splitter.rename

      RSpeed::Redis.clean

      RSpeed::Logger.log('RSpeed finished.')
    end

    def before(example)
      example.update_inherited_metadata(start_at: example.clock.now)
    end

    def before_suite
      clean_profile
    end

    def clean_profile
      RSpeed::Logger.log('[RSpeed::Observer#clean_profile] Cleanning current flag and profile.')

      RSpeed::Redis.destroy(RSpeed::Variable.pipe_name)
      RSpeed::Redis.destroy(RSpeed::Variable.profile)
    end
  end
end
