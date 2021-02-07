# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.append_app_name' do
  context 'when env app is given' do
    it 'appends the rspeed app name on the given value' do
      EnvMock.mock(rspeed_app: 'app') do
        expect(described_class.append_app_name('value')).to eq('value_app')
      end
    end

    context 'when a plus is given' do
      it 'appends the rspeed app name on the given value with the plus value' do
        EnvMock.mock(rspeed_app: 'app', plus: 'plus') do
          expect(described_class.append_app_name('value', plus: 'plus')).to eq('value_app_plus')
        end
      end
    end
  end

  context 'when env app is not given' do
    it 'uses just the given string' do
      expect(described_class.append_app_name('value')).to eq('value')
    end

    context 'when a plus is given' do
      it 'appends the plus value' do
        expect(described_class.append_app_name('value', plus: 'plus')).to eq('value_plus')
      end
    end
  end
end
