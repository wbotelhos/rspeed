# frozen_string_literal: true

RSpec.describe RSpeed::Differ, '#sum_time' do
  let!(:data) { [{ time: 1.4 }, { time: 1.6 }, { time: 2.4 }] }

  it 'sums the time key' do
    expect(described_class.sum_time(data: data)).to be(5.4)
  end
end
