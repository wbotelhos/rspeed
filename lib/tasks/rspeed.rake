# frozen_string_literal: true

require 'csv'

namespace :rspeed do
  task run: :environment do
    if ENV['RSPEED'] = 'true'
      current = ENV['SEMAPHORE_CURRENT_THREAD']
      total   = ENV['SEMAPHORE_THREAD_COUNT']

      if total.present?
        total = total.to_i

        puts "[RSpeed] env.SEMAPHORE_THREAD_COUNT setted to #{total}."
      else
        total = 1

        puts "[RSpeed] env.SEMAPHORE_THREAD_COUNT not provided using #{current} as default..."
      end

      if current.present?
        current = current.to_i

        puts "[RSpeed] env.SEMAPHORE_CURRENT_THREAD setted to #{current}."
      else
        current = 1

        puts "[RSpeed] env.SEMAPHORE_CURRENT_THREAD not provided using #{current} as default..."
      end

      cursor = 1
      data   = CSV.read(Rails.root.join('rspeed.csv')).sort
      stack  = []

      total.times.each { |i| stack[i] = [] }

      data.each do |row|
        if File.exist?(row[0])
          stack[cursor - 1] << row[0]
        else
          puts "[RSpeed] File #{row[0]} missing!"
        end

        cursor = cursor == total ? 1 : cursor + 1
      end

      stack_size = stack[current - 1].size

      if stack_size > 0
        puts "[RSpeed] Running #{stack_size} of #{data.size} specs"

        sh "bundle exec rspec #{stack[current - 1].join(' ')}"
      else
        puts '[RSpeed] No valid specs to run.'
      end
    else
      sh 'bundle exec rspec spec/initializers --tag ~focus'
      sh 'bundle exec rspec spec/models --tag ~focus'
      sh 'bundle exec rspec spec/helpers --tag ~focus'
      sh 'bundle exec rspec spec/decorators --tag ~focus'
      sh 'bundle exec rspec spec/lib --tag ~focus'
      sh 'bundle exec rspec spec/jobs --tag ~focus'
      sh 'bundle exec rspec spec/mailers --tag ~focus'
      sh 'bundle exec rspec spec/routing --tag ~focus'
      sh 'bundle exec rspec spec/services --tag ~focus'
      sh 'bundle exec rspec spec/controllers --tag ~focus'
      sh 'bundle exec rspec spec/features --tag ~focus'
    end
  end
end
