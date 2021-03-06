# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.pipes' do
  context 'when env is setted' do
    it 'returns the env value' do
      EnvMock.mock(rspeed_pipes: '2') do
        expect(described_class.pipes).to be(2)
      end
    end
  end

  context 'when env is not setted' do
    it 'returns number 1' do
      expect(described_class.pipes).to be(1)
    end
  end
end
