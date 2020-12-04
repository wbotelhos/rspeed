# frozen_string_literal: true

require 'json'
require 'support/fakeredis'

RSpec.describe RSpeed::Splitter, '#get' do
  subject(:splitter) { described_class.new }

  let!(:redis) { redis_object }

  context 'when wildcard pattern is given' do
    before do
      redis.set 'rspeed_1', { files: [[1, '1_spec.rb'], [2, '2_spec.rb']], number: 0, total: 3 }.to_json
      redis.set 'rspeed_2', { files: [[3, '3_spec.rb']], number: 1, total: 3 }.to_json
    end

    it 'returns all values' do
      expect(splitter.get('rspeed_*')).to eq [
        {
          'files' => [[1, '1_spec.rb'], [2, '2_spec.rb']],
          'number' => 0,
          'total' => 3,
        },

        {
          'files' => [[3, '3_spec.rb']],
          'number' => 1,
          'total' => 3,
        },
      ]
    end
  end

  context 'when normal pattern is given' do
    before do
      redis.set 'pattern', { files: [[1, '1_spec.rb'], [2, '2_spec.rb']], number: 0, total: 3 }.to_json
    end

    it 'returns all values from that key' do
      expect(splitter.get('pattern')).to eq [
        {
          'files' => [[1, '1_spec.rb'], [2, '2_spec.rb']],
          'number' => 0,
          'total' => 3,
        },
      ]
    end
  end

  context 'when pattern is rspeed' do
    before do
      redis.lpush 'rspeed', { file: '1_spec.rb', time: 1 }.to_json
      redis.lpush 'rspeed', { file: '2_spec.rb', time: 2 }.to_json
    end

    it 'executes the right fetch method' do
      expect(splitter.get('rspeed')).to eq [
        '{"file":"2_spec.rb","time":2}',
        '{"file":"1_spec.rb","time":1}',
      ]
    end
  end

  context 'when pattern is rspeed_tmp' do
    before do
      redis.lpush 'rspeed_tmp', { file: '1_spec.rb', time: 1 }.to_json
      redis.lpush 'rspeed_tmp', { file: '2_spec.rb', time: 2 }.to_json
    end

    it 'executes the right fetch method' do
      expect(splitter.get('rspeed_tmp')).to eq [
        '{"file":"2_spec.rb","time":2}',
        '{"file":"1_spec.rb","time":1}',
      ]
    end
  end
end
