# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#consolidate' do
  let!(:redis) { redis_object }

  before do
    redis.rpush('rspeed', 'rspeed_content')

    redis.rpush('rspeed_profile_01', { file: '1_spec.rb', time: 1.0 }.to_json)
    redis.rpush('rspeed_profile_02', { file: '2_spec.rb', time: 2.0 }.to_json)
    redis.rpush('rspeed_profile_03', { file: '3_spec.rb', time: 3.0 }.to_json)
  end

  it 'copies profiles to the result key cleanning the previous result' do
    described_class.consolidate

    expect(redis.lrange('rspeed', 0, -1)).to eq [
      '{"file":"1_spec.rb","time":1.0}',
      '{"file":"2_spec.rb","time":2.0}',
      '{"file":"3_spec.rb","time":3.0}',
    ]
  end
end
