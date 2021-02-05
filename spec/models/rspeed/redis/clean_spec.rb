# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.clean' do
  it 'destroys all keys that keeps the pipe finished info' do
    described_class.set('rspeed_pipe_1', true)
    described_class.set('rspeed_pipe_2', true)

    described_class.clean

    expect(described_class.keys('*')).to eq([])
  end
end
