# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.db' do
  context 'when key is not setted on env' do
    it { expect(described_class.db).to be(nil) }
  end

  context 'when key is setted on env' do
    it 'returns env value as integer' do
      EnvMock.mock(rspeed_db: '10') do
        expect(described_class.db).to be(10)
      end
    end
  end
end
