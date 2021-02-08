# frozen_string_literal: true

module RSpeed
  module Reporter
    module_function

    require 'terminal-table'

    def call
      diff = RSpeed::Differ.diff

      print_table(
        headings: %w[Item Value],

        rows: [
          ['Actual Time', diff[:actual_time]],
          ['Removed Time', diff[:removed_time]],
          ['Added Time', diff[:added_time]],
        ]
      )
    end

    def print_files(items)
      total_specs = items.size
      headings    = ["#{total_specs} specs", "Pipe #{RSpeed::Env.pipe}/#{RSpeed::Env.pipes}", 'Last Time']

      rows = items.map.with_index do |item, index|
        [format('%02d', index + 1), item[:file], item[:time].to_s]
      end

      print_table(headings: headings, rows: rows)
    end

    def print_table(headings:, rows:)
      puts(Terminal::Table.new(headings: headings, rows: rows))
    end
  end
end
