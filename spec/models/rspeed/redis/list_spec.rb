# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '#list' do
  let!(:redis) { redis_object }

  before do
    redis.rpush('key', { file: '1_spec.rb', time: 1.0 }.to_json)
    redis.rpush('key', { file: '2_spec.rb', time: 2.0 }.to_json)
    redis.rpush('key', { file: '3_spec.rb', time: 3.0 }.to_json)
  end

  it 'list all key entries' do
    expect(described_class.list('key')).to eq [
      '{"file":"1_spec.rb","time":1.0}',
      '{"file":"2_spec.rb","time":2.0}',
      '{"file":"3_spec.rb","time":3.0}',
    ]
  end
end
