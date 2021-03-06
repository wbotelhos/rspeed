# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '.first_pipe?' do
  context 'when pipe env is 1' do
    before { allow(RSpeed::Env).to receive(:pipe).and_return 1 }

    it { expect(described_class.first_pipe?).to eq true }
  end

  context 'when pipe env is not 1' do
    before { allow(RSpeed::Env).to receive(:pipe).and_return 2 }

    it { expect(described_class.first_pipe?).to eq false }
  end
end
