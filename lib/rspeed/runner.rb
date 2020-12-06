# frozen_string_literal: true

module RSpeed
  module Runner
    module_function

    def run(shell, splitter: ::RSpeed::Splitter.new)
      return if splitter.redundant_run?

      RSpeed::Redis.destroy(RSpeed::Variable.tmp) if splitter.first_pipe?

      shell.call(['bundle exec rspec', splitter.pipe_files].compact.join(' '))
    end
  end
end
