# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.port' do
  context 'when key is not setted on env' do
    it { expect(described_class.port).to be(nil) }
  end

  context 'when key is setted on env' do
    it 'returns env value as integer' do
      EnvMock.mock(rspeed_port: '6379') do
        expect(described_class.port).to be(6379)
      end
    end
  end
end
