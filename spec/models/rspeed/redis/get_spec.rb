# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.set' do
  let!(:redis) { redis_object }

  it 'sets a key on redis' do
    redis_object.set('key', 'value')

    expect(described_class.get('key')).to eq('value')
  end
end
