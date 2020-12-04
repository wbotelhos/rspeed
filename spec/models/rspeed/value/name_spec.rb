# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Value, '.name' do
  context 'when env is given' do
    it 'returns the env value' do
      EnvMock.mock(rspeed_name: 'name') do
        expect(described_class.name).to eq('name')
      end
    end
  end

  context 'when env is not given' do
    it { expect(described_class.name).to be(nil) }
  end
end
