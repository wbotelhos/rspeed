# frozen_string_literal: true

module RSpeed
  module Reporter
    module_function

    def call
      RSpeed::Logger.log(self, __method__, 'Reporting...')

    end
  end
end
