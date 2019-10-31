# frozen_string_literal: true

module RSpeed
  module Runner
    module_function

    def run(shell)
      splitter = ::RSpeed::Splitter.new

      if splitter.first_pipe?
        # splitter.destroy "rspeed_*"
        splitter.destroy 'rspeed_tmp'
      end

      if splitter.result?
        splitter.save if splitter.first_pipe?

        files = splitter.get("rspeed_#{splitter.pipe}")[0]['files'].map { |item| item['file'] }.join(' ')
      end

      shell.call ['bundle exec rspec', files].compact.join(' ')

      splitter.append

      splitter.rename if splitter.last_pipe?
    end
  end
end