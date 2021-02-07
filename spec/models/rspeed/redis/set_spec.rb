# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.set' do
  let!(:redis) { redis_object }

  it 'sets a key on redis' do
    described_class.set('key', 'value')

    expect(redis.get('key')).to eq('value')
  end
end
