# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#pipe' do
  subject(:splitter) { described_class.new }

  context 'when pipe env is given' do
    before { ENV['RSPEED_PIPE'] = '2' }

    it 'returns the number of the current pipe' do
      expect(splitter.pipe).to eq 2
    end
  end

  context 'when pipe env is not given' do
    it 'returns 1' do
      expect(splitter.pipe).to eq 1
    end
  end
end
