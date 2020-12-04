# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.tmp' do
  it { expect(described_class.tmp).to eq('rspeed_tmp') }

  context 'when env name is given' do
    it 'includes the name' do
      EnvMock.mock(rspeed_name: 'name') do
        expect(described_class.tmp).to eq('rspeed_tmp_name')
      end
    end
  end
end
