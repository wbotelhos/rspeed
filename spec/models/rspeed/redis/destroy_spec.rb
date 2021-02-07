# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '#destroy' do
  before do
    redis_object.set('rspeed', '{}')
    redis_object.set('rspeed_1', '{}')
    redis_object.set('rspeed_2', '{}')
  end

  it 'destroys via wildcard' do
    described_class.destroy(pattern: 'rspeed_*')

    expect(redis_object.keys('*')).to eq %w[rspeed]
  end

  it 'destroys via single name' do
    described_class.destroy(pattern: 'rspeed')

    expect(redis_object.keys('*')).to eq %w[rspeed_1 rspeed_2]
  end
end
