# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.append_name' do
  context 'when env name is given' do
    it 'appends the rspeed name on the given value' do
      EnvMock.mock(rspeed_name: 'name') do
        expect(described_class.append_name('value')).to eq('value_name')
      end
    end
  end

  context 'when env name is not given' do
    it 'ignores the suffix' do
      expect(described_class.append_name('value')).to eq('value')
    end
  end
end
