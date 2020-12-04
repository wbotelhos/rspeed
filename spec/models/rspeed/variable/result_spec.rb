# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.result' do
  it { expect(described_class.result).to eq('rspeed') }

  context 'when env name is given' do
    it 'includes the name' do
      EnvMock.mock(rspeed_name: 'name') do
        expect(described_class.result).to eq('rspeed_name')
      end
    end
  end

  context 'when env name is not given' do
    it { expect(described_class.result).to eq('rspeed') }
  end
end
