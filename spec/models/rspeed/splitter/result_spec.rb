# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#result?' do
  subject(:splitter) { described_class.new }

  context 'when has no key rspeed on redis' do
    it { expect(splitter.result?).to eq false }
  end

  context 'when has no key rspeed on redis' do
    let!(:redis) { Redis.new db: 14, host: 'localhost', port: 6379 }

    before { redis.set 'rspeed', { files: [[1, '1_spec.rb']], number: 0, total: 1 }.to_json }

    it { expect(splitter.result?).to eq true }
  end
end
