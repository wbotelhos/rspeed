# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.previous_result' do
  it { expect(described_class.previous_result).to eq('rspeed_previous') }

  context 'when env app is given' do
    it 'includes the app' do
      EnvMock.mock(rspeed_app: 'app') do
        expect(described_class.previous_result).to eq('rspeed_app_previous')
      end
    end
  end

  context 'when env app is not given' do
    it { expect(described_class.previous_result).to eq('rspeed_previous') }
  end
end
