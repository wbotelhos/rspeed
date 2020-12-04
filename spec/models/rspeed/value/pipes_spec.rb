# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Value, '.pipes' do
  context 'when result is false' do
    context 'when env is setted' do
      it 'returns number 1' do
        EnvMock.mock(rspeed_pipes: '2') do
          expect(described_class.pipes(false)).to be(1)
        end
      end
    end

    context 'when env is not setted' do
      it 'returns number 1' do
        expect(described_class.pipes(false)).to be(1)
      end
    end
  end

  context 'when result is true' do
    context 'when env is setted' do
      it 'returns the env value as integer' do
        EnvMock.mock(rspeed_pipes: '2') do
          expect(described_class.pipes(true)).to be(2)
        end
      end
    end

    context 'when env is not setted' do
      it 'returns number 1' do
        expect(described_class.pipes(true)).to be(1)
      end
    end
  end
end
