# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Splitter, '.keys' do
  subject(:splitter) { described_class.new }

  let!(:redis) { Redis.new db: 14, host: 'localhost', port: 6379 }

  context 'with default config' do
    before do
      redis.set 'rspeed_1', 'value_1'
      redis.set 'rspeed_2', 'value_2'
      redis.set 'rspeed_3', 'value_3'
    end

    it 'shows keys' do
      expect(splitter.keys).to eq %w[rspeed_1 rspeed_2 rspeed_3]
    end
  end

  context 'with custom key' do
    before do
      redis.set 'custom_key_1', 'value_1'
      redis.set 'custom_key_2', 'value_2'
      redis.set 'custom_key_3', 'value_3'
    end

    it 'shows keys' do
      expect(splitter.keys('custom_key_*')).to eq %w[custom_key_1 custom_key_2 custom_key_3]
    end
  end
end
