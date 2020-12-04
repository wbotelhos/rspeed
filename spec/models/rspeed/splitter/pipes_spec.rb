# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Splitter, '#pipes' do
  subject(:splitter) { described_class.new }

  context 'when has no result' do
    before { allow(splitter).to receive(:result?).and_return(false) }

    it 'the number of pipes is adjusted to one' do
      expect(splitter.pipes).to be(1)
    end
  end

  context 'when has result' do
    before { allow(splitter).to receive(:result?).and_return(true) }

    it 'is used the given value on env' do
      EnvMock.mock(rspeed_pipes: '2') do
        expect(splitter.pipes).to be(2)
      end
    end
  end
end
