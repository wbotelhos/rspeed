# frozen_string_literal: true

RSpec.describe RSpeed::Reporter, '#call' do
  let!(:previous_result) do
    [
      { file: './spec/fixtures/1_spec.rb:1', time: 1.1 },
      { file: './spec/fixtures/2_spec.rb:2', time: 2.2 },
      { file: './spec/fixtures/3_spec.rb:3', time: 3.3 },
      { file: './spec/fixtures/4_spec.rb:4', time: 4.4 },
    ]
  end

  let!(:result) do
    [
      { file: './spec/fixtures/1_spec.rb:1', time: 1.1 },
      { file: './spec/fixtures/2_spec.rb:2', time: 2.2 },
      { file: './spec/fixtures/5_spec.rb:5', time: 5.5 },
      { file: './spec/fixtures/6_spec.rb:6', time: 6.6 },
    ]
  end

  before do
    allow(RSpeed::Database).to receive(:previous_result).and_return(previous_result)
    allow(RSpeed::Database).to receive(:result).and_return(result)
  end

  it 'prints a report' do
    output = <<~HEREDOC
      +--------------+-------+
      |        RSpeed        |
      +--------------+-------+
      | Global       | Value |
      +--------------+-------+
      | Actual Time  | 15.4  |
      | Removed Time | 7.7   |
      | Added Time   | 12.1  |
      +--------------+-------+
    HEREDOC

    expect { described_class.call }.to output(output).to_stdout
  end
end
