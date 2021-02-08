# frozen_string_literal: true

RSpec.describe RSpeed::Reporter, '#print_files' do
  let!(:items) do
    [
      { file: './spec/fixtures/1_spec.rb:1', time: 1.1 },
      { file: './spec/fixtures/2_spec.rb:2', time: 2.2 },
      { file: './spec/fixtures/3_spec.rb:3', time: 3.3 },
    ]
  end

  it 'prints the attributes' do
    output = <<~HEREDOC
      +---------+-----------------------------+-----------+
      |                      RSpeed                       |
      +---------+-----------------------------+-----------+
      | 3 specs | Pipe 1/1                    | Last Time |
      +---------+-----------------------------+-----------+
      | 01      | ./spec/fixtures/1_spec.rb:1 | 1.1       |
      | 02      | ./spec/fixtures/2_spec.rb:2 | 2.2       |
      | 03      | ./spec/fixtures/3_spec.rb:3 | 3.3       |
      +---------+-----------------------------+-----------+
    HEREDOC

    expect { described_class.print_files(items) }.to output(output).to_stdout
  end
end
