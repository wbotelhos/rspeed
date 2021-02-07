# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.spec_path' do
  context 'when env is given' do
    it 'is returned' do
      EnvMock.mock(rspeed_spec_path: './test/**/*test.rb') do
        expect(described_class.spec_path).to eq('./test/**/*test.rb')
      end
    end
  end

  context 'when env is not given' do
    it 'returns the default' do
      expect(described_class.spec_path).to eq('./spec/**/*spec.rb')
    end
  end
end
