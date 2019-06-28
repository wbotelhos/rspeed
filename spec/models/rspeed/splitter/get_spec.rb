# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#get' do
  subject(:splitter) { described_class.new }

  let!(:redis) { Redis.new db: 14, host: 'localhost', port: 6379 }

  before do
    redis.set 'rspeed_0', { files: [[1, '1_spec.rb'], [2, '2_spec.rb']], number: 0, total: 3 }.to_json
    redis.set 'rspeed_1', { files: [[3, '3_spec.rb']], number: 1, total: 3 }.to_json
  end

  context 'when no pattern is given' do
    it 'returns only the actual specs with the news on first key' do
      expect(splitter.get).to eq [
        {
          'files' => [[1, '1_spec.rb'], [2, '2_spec.rb']],
          'number' => 0,
          'total' => 3
        },

        {
          'files' => [[3, '3_spec.rb']],
          'number' => 1,
          'total' => 3
        }
      ]
    end
  end
end
