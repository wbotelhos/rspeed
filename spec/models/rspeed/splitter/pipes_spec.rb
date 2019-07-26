# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#pipes' do
  subject(:splitter) { described_class.new }

  context 'when has no key rspeed_* on redis' do
    before { ENV['RSPEED_PIPES'] = '2' }

    it 'ignores env and returns 1' do
      expect(splitter.pipes).to eq 1
    end
  end

  context 'when has key rspeed_* on redis' do
    let!(:redis) { Redis.new db: 14, host: 'localhost', port: 6379 }

    before do
      redis.set 'rspeed_1', { files: [[1, '1_spec.rb']], number: 0, total: 1 }.to_json
    end

    context 'when pipe env is given' do
      before { ENV['RSPEED_PIPES'] = '2' }

      it 'returns the number of the current pipe' do
        expect(splitter.pipes).to eq 2
      end
    end

    context 'when pipe env is not given' do
      before { ENV.delete 'RSPEED_PIPES' }

      it 'returns 1' do
        expect(splitter.pipes).to eq 1
      end
    end
  end
end
