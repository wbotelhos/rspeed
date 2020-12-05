# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Variable, '.pipe_name' do
  it { expect(described_class.pipe_name).to eq('rspeed_pipe_1') }

  context 'when env name is given' do
    it 'includes the name' do
      EnvMock.mock(rspeed_name: 'name') do
        expect(described_class.pipe_name).to eq('rspeed_pipe_name_1')
      end
    end
  end
end
