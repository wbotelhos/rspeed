# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.pipe' do
  it { expect(described_class.pipe).to eq('rspeed_pipe_1') }

  context 'when env name is given' do
    it 'includes the name' do
      EnvMock.mock(rspeed_name: 'app') do
        expect(described_class.pipe).to eq('rspeed_pipe_app_1')
      end
    end
  end
end
