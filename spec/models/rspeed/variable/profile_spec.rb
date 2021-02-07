# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.profile' do
  it { expect(described_class.profile).to eq('rspeed_profile_01') }

  context 'when env name is given' do
    it 'includes the name' do
      EnvMock.mock(rspeed_app: 'name') do
        expect(described_class.profile).to eq('rspeed_profile_name_01')
      end
    end
  end

  context 'when pipe is bigger than 9' do
    it 'does not prefix zero on the number' do
      EnvMock.mock(rspeed_pipe: 10) do
        expect(described_class.profile).to eq('rspeed_profile_10')
      end
    end
  end
end
