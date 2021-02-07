# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.after_suite' do
  context 'when all specs is not finished' do
    let!(:redis) { redis_object }

    before { allow(RSpeed::Redis).to receive(:specs_finished?).and_return(false) }

    it 'sets true on pipe key to indicates that its finished' do
      described_class.after_suite

      expect(redis.get('rspeed:pipe_01')).to eq('true')
    end
  end

  context 'when all specs finished' do
    before do
      allow(RSpeed::Redis).to receive(:specs_finished?).and_return(true)
      allow(RSpeed::Splitter).to receive(:consolidate)
      allow(RSpeed::Redis).to receive(:clean)
    end

    it 'consolidates profiles' do
      described_class.after_suite

      expect(RSpeed::Splitter).to have_received(:consolidate)
    end

    it 'destroyes pipe finished flag keys' do
      described_class.after_suite

      expect(RSpeed::Redis).to have_received(:clean)
    end
  end
end
