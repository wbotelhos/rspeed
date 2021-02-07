# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.key' do
  it { expect(described_class.key(1)).to be(:rspeed_1) }

  context 'when env app is given' do
    it 'includes the app' do
      EnvMock.mock(rspeed_app: 'app') do
        expect(described_class.key(1)).to be(:rspeed_app_1)
      end
    end
  end
end
