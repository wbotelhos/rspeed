# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#append?' do
  subject(:splitter) { described_class.new }

  context 'when has no result' do
    before { allow(RSpeed::Redis).to receive(:result?).and_return(false) }

    context 'when is not the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(false) }

      it { expect(splitter.append?).to be(false) }
    end

    context 'when is the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(true) }

      it { expect(splitter.append?).to be(true) }
    end
  end

  context 'when has result' do
    before { allow(RSpeed::Redis).to receive(:result?).and_return(true) }

    context 'when is not the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(false) }

      it { expect(splitter.append?).to be(true) }
    end

    context 'when is the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(true) }

      it { expect(splitter.append?).to be(true) }
    end
  end
end
