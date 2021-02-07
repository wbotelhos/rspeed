# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.clean' do
  it 'destroys all keys that keeps the pipe finished info' do
    redis_object.set('rspeed:pipe_01', true)
    redis_object.set('rspeed:pipe_02', true)

    described_class.clean

    expect(redis_object.keys('*')).to eq([])
  end

  it 'destroys the pipe profiles' do
    redis_object.set('rspeed:profile_01', true)

    described_class.clean

    expect(redis_object.keys('*')).to eq([])
  end
end
