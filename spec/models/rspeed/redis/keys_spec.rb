# frozen_string_literal: true

require 'support/fakeredis'

RSpec.describe RSpeed::Redis, '.keys' do
  subject(:splitter) { described_class }

  context 'with default config' do
    before do
      described_class.set('rspeed_1', 'value_1')
      described_class.set('rspeed_2', 'value_2')
      described_class.set('rspeed_3', 'value_3')
    end

    it 'shows keys' do
      expect(splitter.keys).to eq %w[rspeed_1 rspeed_2 rspeed_3]
    end
  end

  context 'with custom key' do
    before do
      described_class.set('custom_key_1', 'value_1')
      described_class.set('custom_key_2', 'value_2')
      described_class.set('custom_key_3', 'value_3')
    end

    it 'shows keys' do
      expect(splitter.keys('custom_key_*')).to eq %w[custom_key_1 custom_key_2 custom_key_3]
    end
  end
end
