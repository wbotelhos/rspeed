# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.clean_pipes_flag' do
  before do
    described_class.set('rspeed_pipe_1', true)
    described_class.set('rspeed_pipe_2', true)
  end

  it 'destroy all keys that keeps the pipe finished' do
    described_class.clean_pipes_flag

    expect(described_class.keys('*')).to eq([])
  end
end
