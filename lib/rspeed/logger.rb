# frozen_string_literal: true

module RSpeed
  module Logger
    module_function

    def log(context, method, message)
      clazz = context.ancestors.join('::')

      puts("[#{clazz}##{method}.#{RSpeed::Env.pipe}] #{message}")
    end
  end
end
