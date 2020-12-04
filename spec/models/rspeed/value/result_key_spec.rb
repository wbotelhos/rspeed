# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.result_key' do
  context 'when key is not setted on env' do
    it 'returns default value' do
      expect(described_class.result_key).to eq 'rspeed'
    end
  end

  context 'when key is setted on env' do
    it 'returns env value' do
      EnvMock.mock(respeed_result_key: 'result_customer') do
        expect(described_class.result_key).to eq 'result_customer'
      end
    end
  end
end
