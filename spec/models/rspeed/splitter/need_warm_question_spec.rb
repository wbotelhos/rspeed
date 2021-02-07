# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#need_warm?' do
  context 'when has no result' do
    before { allow(RSpeed::Redis).to receive(:result?).and_return(false) }

    context 'when is not the first pipe' do
      before { allow(described_class).to receive(:first_pipe?).and_return(false) }

      it { expect(described_class.need_warm?).to be(false) }
    end

    context 'when is the first pipe' do
      before { allow(described_class).to receive(:first_pipe?).and_return(true) }

      it { expect(described_class.need_warm?).to be(true) }
    end
  end

  context 'when has result' do
    before { allow(RSpeed::Redis).to receive(:result?).and_return(true) }

    context 'when is not the first pipe' do
      before { allow(described_class).to receive(:first_pipe?).and_return(false) }

      it { expect(described_class.need_warm?).to be(false) }
    end

    context 'when is the first pipe' do
      before { allow(described_class).to receive(:first_pipe?).and_return(true) }

      it { expect(described_class.need_warm?).to be(false) }
    end
  end
end
