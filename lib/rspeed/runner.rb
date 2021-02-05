# frozen_string_literal: true

module RSpeed
  module Runner
    module_function

    def run(shell, splitter: ::RSpeed::Splitter.new)
      return shell.call(['bundle exec rspec', splitter.pipe_files].compact.join(' ')) if splitter.need_warm?

      RSpeed::Logger.log("Pipe #{RSpeed::Env.pipe} skipped. Only Pipe 1 can warm.")

      RSpeed::Observer.after_suite
    end
  end
end
