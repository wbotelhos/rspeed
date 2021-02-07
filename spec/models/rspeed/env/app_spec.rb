# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.app' do
  context 'when env is given' do
    it 'returns the env value' do
      EnvMock.mock(rspeed_app: 'app') do
        expect(described_class.app).to eq('app')
      end
    end
  end

  context 'when env is not given' do
    it { expect(described_class.app).to be(nil) }
  end
end
