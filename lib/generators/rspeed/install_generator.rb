# frozen_string_literal: true

module RSpeed
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'Creates RSpeed task'

    def copy_initializer
      copy_file 'lib/tasks/rspeed.rake', 'lib/tasks/rspeed.rake'
    end
  end
end
