# frozen_string_literal: true

require 'support/fakeredis'

RSpec.describe RSpeed::Splitter, '.redundant_run?' do
  subject(:splitter) { described_class.new }

  context 'when is not pipe 1' do
    before { allow(splitter).to receive(:pipe).and_return(2) }

    context 'when result key exists' do
      let!(:redis) { redis_object }

      before do
        redis.set('rspeed', '{}')

        allow(splitter).to receive(:pipe).and_return(2)
      end

      it { expect(splitter.redundant_run?).to be(false) }
    end

    context 'when result key does not exist' do
      it { expect(splitter.redundant_run?).to be(true) }
    end
  end

  context 'when is the first pipe' do
    before { allow(splitter).to receive(:pipe).and_return(1) }

    context 'when result key exists' do
      let!(:redis) { redis_object }

      before do
        redis.set('rspeed', '{}')

        allow(splitter).to receive(:pipe).and_return(2)
      end

      it { expect(splitter.redundant_run?).to be(false) }
    end

    context 'when result key does not exist' do
      it { expect(splitter.redundant_run?).to be(false) }
    end
  end
end
