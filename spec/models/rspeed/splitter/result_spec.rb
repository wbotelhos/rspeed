# frozen_string_literal: true

require 'json'
require 'support/fakeredis'

RSpec.describe RSpeed::Splitter, '#result?' do
  subject(:splitter) { described_class.new }

  context 'when has no key rspeed on redis' do
    it { expect(splitter.result?).to eq false }
  end

  context 'when has no key rspeed on redis' do
    let!(:redis) { redis_object }

    before { redis.set 'rspeed', { files: [[1, '1_spec.rb']], number: 0, total: 1 }.to_json }

    it { expect(splitter.result?).to eq true }
  end
end
