# frozen_string_literal: true

module RSpeed
  module Observer
    module_function

    def after(example)
      file_path   = example.metadata[:file_path]
      line_number = example.metadata[:line_number]
      spent_time  = example.clock.now - example.metadata[:start_at]

      json = { file: "#{file_path}:#{line_number}", time: spent_time }.to_json

      RSpeed::Redis.client.rpush(RSpeed::Variable.profile, json)
    end

    def after_suite
      RSpeed::Redis.set(RSpeed::Variable.pipe, true)

      return unless RSpeed::Redis.specs_finished?

      RSpeed::Splitter.consolidate

      RSpeed::Redis.clean

      RSpeed::Logger.log(self, __method__, 'RSpeed finished.')
    end

    def before(example)
      example.update_inherited_metadata(start_at: example.clock.now)
    end

    def before_suite
      RSpeed::Logger.log(self, __method__, 'Cleanning current flag and profile.')

      RSpeed::Redis.destroy(pattern: RSpeed::Variable.pipe)
      RSpeed::Redis.destroy(pattern: RSpeed::Variable.profile)
    end
  end
end
