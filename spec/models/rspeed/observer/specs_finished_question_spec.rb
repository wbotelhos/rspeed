# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Observer, '.specs_finished?' do
  before { RSpeed::Redis.set('rspeed_pipe_1', '1.0') }

  context 'when we do not have the information about finishing the pipes' do
    it 'returns false' do
      EnvMock.mock(rspeed_pipes: 2) do
        expect(described_class.specs_finished?).to be(false)
      end
    end
  end

  context 'when we have the information about finishing the pipes' do
    before { RSpeed::Redis.set('rspeed_pipe_2', '2.0') }

    it 'returns false' do
      EnvMock.mock(rspeed_pipes: 2) do
        expect(described_class.specs_finished?).to be(true)
      end
    end
  end
end
