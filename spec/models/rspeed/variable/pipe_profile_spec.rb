# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.profile' do
  it { expect(described_class.profile).to eq('rspeed_profile_1') }

  context 'when env name is given' do
    it 'includes the name' do
      EnvMock.mock(rspeed_app: 'name') do
        expect(described_class.profile).to eq('rspeed_profile_name_1')
      end
    end
  end
end
