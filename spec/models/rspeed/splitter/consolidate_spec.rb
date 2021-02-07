# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#consolidate' do
  subject(:splitter) { described_class.new }

  let!(:redis) { redis_object }

  before do
    redis.lpush('rspeed', 'rspeed_content')

    redis.lpush('rspeed_profile_1', { file: '1_spec.rb', time: 1.0 }.to_json)
    redis.lpush('rspeed_profile_2', { file: '2_spec.rb', time: 2.0 }.to_json)
    redis.lpush('rspeed_profile_3', { file: '3_spec.rb', time: 3.0 }.to_json)
  end

  it 'copies profiles to the result key cleanning the previous result' do
    splitter.consolidate

    expect(redis.lrange('rspeed', 0, -1)).to eq [
      '{"file":"1_spec.rb","time":1.0}',
      '{"file":"2_spec.rb","time":2.0}',
      '{"file":"3_spec.rb","time":3.0}',
    ]
  end
end
