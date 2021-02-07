# frozen_string_literal: true

RSpec.describe RSpeed::Differ, '#actual_data' do
  let!(:files) { ['./spec/fixtures/1_spec.rb:4', './spec/fixtures/1_spec.rb:6', './spec/fixtures/new_spec.rb:1'] }

  let!(:result) do
    [
      { file: './spec/fixtures/1_spec.rb:4', time: 1.4 },
      { file: './spec/fixtures/1_spec.rb:6', time: 1.6 },
      { file: './spec/fixtures/2_spec.rb:4', time: 2.4 },
    ]
  end

  it 'returns only consolidated data still existent as spec' do
    expect(described_class.actual_data(files: files, result: result)).to eq [
      { file: './spec/fixtures/1_spec.rb:4', time: 1.4 },
      { file: './spec/fixtures/1_spec.rb:6', time: 1.6 },
    ]
  end
end
