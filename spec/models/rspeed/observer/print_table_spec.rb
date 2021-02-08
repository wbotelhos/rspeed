# frozen_string_literal: true

RSpec.describe RSpeed::Reporter, '#print_table' do
  let!(:headings) { %w[Item Value] }

  let!(:rows) do
    [
      ['Actual Time', 1.0],
      ['Removed Time', 2.0],
      ['Added Time', 3.0],
    ]
  end

  it 'prints' do
    output = <<~HEREDOC
      +--------------+-------+
      | Item         | Value |
      +--------------+-------+
      | Actual Time  | 1.0   |
      | Removed Time | 2.0   |
      | Added Time   | 3.0   |
      +--------------+-------+
    HEREDOC

    expect { described_class.print_table(headings: headings, rows: rows) }.to output(output).to_stdout
  end
end
