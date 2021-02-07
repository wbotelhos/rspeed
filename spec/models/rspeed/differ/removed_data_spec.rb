# frozen_string_literal: true

RSpec.describe RSpeed::Differ, '#removed_data' do
  let!(:files) { ['./spec/fixtures/2_spec.rb:4'] }

  let!(:result) do
    [
      { file: './spec/fixtures/1_spec.rb:4', time: 1.4 },
      { file: './spec/fixtures/1_spec.rb:6', time: 1.6 },
      { file: './spec/fixtures/2_spec.rb:4', time: 2.4 },
    ]
  end

  it 'returns only removed data' do
    expect(described_class.removed_data(files: files, result: result)).to eq [
      { file: './spec/fixtures/1_spec.rb:4', time: 1.4 },
      { file: './spec/fixtures/1_spec.rb:6', time: 1.6 },
    ]
  end
end
