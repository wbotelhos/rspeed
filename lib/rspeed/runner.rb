# frozen_string_literal: true

module RSpeed
  module Runner
    module_function

    def run(shell)
      if RSpeed::Redis.result? || RSpeed::Splitter.first_pipe?
        return shell.call(['bundle exec rspec', RSpeed::Splitter.pipe_files].compact.join(' '))
      end

      RSpeed::Logger.log(self, __method__, 'Skipped! Only Pipe 1 can warm.')

      RSpeed::Observer.after_suite
    end
  end
end
