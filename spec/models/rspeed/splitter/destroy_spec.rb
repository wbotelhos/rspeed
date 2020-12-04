# frozen_string_literal: true

require 'support/fakeredis'

RSpec.describe RSpeed::Splitter, '#destroy' do
  subject(:splitter) { described_class.new }

  let!(:redis) { redis_object }

  before do
    redis.set 'rspeed',   '{}'
    redis.set 'rspeed_1', '{}'
    redis.set 'rspeed_2', '{}'
  end

  it 'destroys via wildcard' do
    splitter.destroy 'rspeed_*'

    expect(splitter.keys('*')).to eq %w[rspeed]
  end

  it 'destroys via single name' do
    splitter.destroy 'rspeed'

    expect(splitter.keys('*')).to eq %w[rspeed_1 rspeed_2]
  end

  it 'destroys default partner when no pattern is given' do
    splitter.destroy

    expect(splitter.keys('*')).to eq %w[rspeed]
  end
end
