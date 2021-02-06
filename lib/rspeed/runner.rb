# frozen_string_literal: true

module RSpeed
  module Runner
    module_function

    def run(shell, splitter: ::RSpeed::Splitter.new)
      if RSpeed::Redis.result? || splitter.first_pipe?
        return shell.call(['bundle exec rspec', splitter.pipe_files].compact.join(' '))
      end

      RSpeed::Logger.log("Pipe #{RSpeed::Env.pipe} skipped. Only Pipe 1 can warm.")

      RSpeed::Observer.after_suite
    end
  end
end
