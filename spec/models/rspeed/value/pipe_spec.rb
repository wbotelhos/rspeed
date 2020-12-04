# frozen_string_literal: true

RSpec.describe RSpeed::Value, '.pipe' do
  context 'when pipe env is given' do
    before { ENV['RSPEED_PIPE'] = '2' }

    it 'returns the number of the current pipe' do
      expect(described_class.pipe).to eq 2
    end
  end

  context 'when pipe env is not given' do
    it 'returns 1' do
      expect(described_class.pipe).to eq 1
    end
  end
end
