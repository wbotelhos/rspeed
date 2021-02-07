# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.before_suite' do
  let!(:redis) { redis_object }

  before { truncate_profiles }
  after { truncate_profiles }

  it 'cleans only the current pipe profile' do
    redis.rpush('rspeed_profile_01', { file: '1_spec.rb', time: 1 }.to_json)
    redis.rpush('rspeed_profile_02', { file: '2_spec.rb', time: 2 }.to_json)

    described_class.before_suite

    expect(redis.keys).to eq ['rspeed_profile_02']
  end

  it 'cleans the pipe flag' do
    redis.set('rspeed_pipe_01', true)
    redis.set('rspeed_pipe_02', true)

    described_class.before_suite

    expect(redis.keys).to eq ['rspeed_pipe_02']
  end
end
