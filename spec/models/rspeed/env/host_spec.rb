# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.host' do
  context 'when key is not setted on env' do
    it { expect(described_class.host).to be(nil) }
  end

  context 'when key is setted on env' do
    it 'returns env value' do
      EnvMock.mock(rspeed_host: 'localhost') do
        expect(described_class.host).to eq('localhost')
      end
    end
  end
end
