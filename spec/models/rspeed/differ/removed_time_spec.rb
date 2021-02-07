# frozen_string_literal: true

RSpec.describe RSpeed::Differ, '#removed_time' do
  let!(:data) do
    [
      { file: './spec/fixtures/1_spec.rb:4', time: 1.4 },
      { file: './spec/fixtures/1_spec.rb:6', time: 1.6 },
    ]
  end

  it 'returns the sum of removed examples' do
    expect(described_class.removed_time(data: data)).to be(3.0)
  end
end
