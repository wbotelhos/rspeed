# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '.last_pipe?' do
  subject(:splitter) { described_class.new }

  before { allow(splitter).to receive(:pipes).and_return 3 }

  context 'when pipe env is equal pipes env' do
    before { allow(splitter).to receive(:pipe).and_return 3 }

    it { expect(splitter.last_pipe?).to eq true }
  end

  context 'when pipe env not equal pipes env' do
    before { allow(splitter).to receive(:pipe).and_return 2 }

    it { expect(splitter.last_pipe?).to eq false }
  end
end
