# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Value, '.pipe' do
  context 'when pipe env is given' do
    it 'returns the number of the current pipe as integer' do
      EnvMock.mock(rspeed_pipe: '2') do
        expect(described_class.pipe).to be(2)
      end
    end
  end

  context 'when pipe env is not given' do
    it 'returns 1' do
      expect(described_class.pipe).to be(1)
    end
  end
end
