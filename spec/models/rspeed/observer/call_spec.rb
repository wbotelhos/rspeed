# frozen_string_literal: true

RSpec.describe RSpeed::Reporter, '#call' do
  let!(:files) { ['./spec/fixtures/1_spec.rb:4', './spec/fixtures/rm_spec.rb:1', './spec/fixtures/rm_spec.rb:2'] }

  let!(:result) do
    [
      { file: './spec/fixtures/1_spec.rb:4', time: 1.4 },
      { file: './spec/fixtures/rm_spec.rb:1', time: 1.1 },
      { file: './spec/fixtures/rm_spec.rb:2', time: 2.2 },
    ]
  end

  before do
    allow(RSpeed::Differ).to receive(:actual_files).and_return(files)
    allow(RSpeed::Database).to receive(:result).and_return(result)
  end

  it 'prints a report' do
    output = <<~HEREDOC
      +--------------+-------+
      | Item         | Value |
      +--------------+-------+
      | Actual Time  | 4.7   |
      | Removed Time | 0     |
      | Added Time   | 0     |
      +--------------+-------+
    HEREDOC

    expect { described_class.call }.to output(output).to_stdout
  end
end
