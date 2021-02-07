# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '#profiles_content' do
  let!(:redis) { redis_object }

  before do
    redis.lpush('rspeed_profile_1', { file: '1_spec.rb', time: 1.0 }.to_json)
    redis.lpush('rspeed_profile_2', { file: '2_spec.rb', time: 2.0 }.to_json)
    redis.lpush('rspeed_profile_3', { file: '3_spec.rb', time: 3.0 }.to_json)
  end

  it 'returns the content of all profiles keys' do
    expect(described_class.profiles_content).to eq [
      '{"file":"1_spec.rb","time":1.0}',
      '{"file":"2_spec.rb","time":2.0}',
      '{"file":"3_spec.rb","time":3.0}',
    ]
  end
end
