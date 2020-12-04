# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Env, '.rspeed' do
  context 'when env is given' do
    context 'when true as string' do
      it 'true' do
        EnvMock.mock(rspeed: 'true') do
          expect(described_class.rspeed).to be(true)
        end
      end
    end

    context 'when true' do
      it 'true' do
        EnvMock.mock(rspeed: true) do
          expect(described_class.rspeed).to be(true)
        end
      end
    end

    context 'when false as string' do
      it 'false' do
        EnvMock.mock(rspeed: 'false') do
          expect(described_class.rspeed).to be(false)
        end
      end
    end

    context 'when false' do
      it 'false' do
        EnvMock.mock(rspeed: false) do
          expect(described_class.rspeed).to be(false)
        end
      end
    end
  end

  context 'when env is not given' do
    it { expect(described_class.rspeed).to be(false) }
  end
end
