# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '#destroy' do
  let!(:redis) { described_class }

  before do
    redis.set('rspeed', '{}')
    redis.set('rspeed_1', '{}')
    redis.set('rspeed_2', '{}')
  end

  it 'destroys via wildcard' do
    redis.destroy(pattern: 'rspeed_*')

    expect(redis.keys('*')).to eq %w[rspeed]
  end

  it 'destroys via single name' do
    redis.destroy(pattern: 'rspeed')

    expect(redis.keys('*')).to eq %w[rspeed_1 rspeed_2]
  end
end
