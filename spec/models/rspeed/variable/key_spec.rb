# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.key' do
  it { expect(described_class.key(1)).to be(:rspeed_1) }

  context 'when env name is given' do
    it 'includes the name' do
      EnvMock.mock(rspeed_name: 'name') do
        expect(described_class.key(1)).to be(:rspeed_name_1)
      end
    end
  end
end
