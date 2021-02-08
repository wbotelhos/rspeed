# frozen_string_literal: true

RSpec.describe RSpeed::Differ, '#added_data' do
  let!(:files) { ['./spec/fixtures/1_spec.rb:4', './spec/fixtures/1_spec.rb:6', './spec/fixtures/new_spec.rb:4'] }

  let!(:result) do
    [
      { file: './spec/fixtures/1_spec.rb:4', time: 1.4 },
      { file: './spec/fixtures/1_spec.rb:6', time: 1.6 },
      { file: './spec/fixtures/2_spec.rb:4', time: 2.4 },
    ]
  end

  it 'returns the added data files with time as zero since we do not know yet' do
    expect(described_class.added_data(files: files, result: result)).to eq [
      { file: './spec/fixtures/new_spec.rb:4', time: 0.0 },
    ]
  end
end
