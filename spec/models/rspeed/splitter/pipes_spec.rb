# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#pipes' do
  subject(:splitter) { described_class.new }

  context 'when has no result' do
    before { allow(splitter).to receive(:has_result?).and_return(false) }

    it 'the number of pipes is adjusted to one' do
      expect(splitter.pipes).to eq 1
    end
  end

  context 'when has result' do
    before do
      allow(splitter).to receive(:has_result?).and_return(true)

      ENV['RSPEED_PIPES'] = '2'
    end

    it 'is used the given value on env' do
      expect(splitter.pipes).to eq 2
    end
  end
end
