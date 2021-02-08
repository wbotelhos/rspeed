# frozen_string_literal: true

RSpec.describe RSpeed::Differ, '#sum_time' do
  context 'when has at least one time with value' do
    let!(:data) { [{ time: 1.4 }, { time: 1.6 }, { time: 2.4 }, { time: nil }] }

    it 'sums the time key' do
      expect(described_class.sum_time(data: data)).to be(5.4)
    end
  end

  context 'when all time are nil' do
    let!(:data) { [{ time: nil }, { time: nil }] }

    it 'returns a question mark' do
      expect(described_class.sum_time(data: data)).to eq('?')
    end
  end
end
