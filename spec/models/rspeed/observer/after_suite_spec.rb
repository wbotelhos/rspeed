# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.after' do
  let!(:splitter) { instance_double('RSpeed::Splitter') }

  before do
    allow(RSpeed::Splitter).to receive(:new).and_return(splitter)
    allow(splitter).to receive(:append)
  end

  context 'when all specs is not finished' do
    before { allow(described_class).to receive(:specs_finished?).and_return(false) }

    it 'sets true on pipe key to indicates that its finished' do
      described_class.after_suite

      expect(RSpeed::Redis.get('rspeed_pipe_1')).to eq('true')
    end

    it 'appends the time result' do
      described_class.after_suite

      expect(splitter).to have_received(:append)
    end
  end

  context 'when all specs finished' do
    before { allow(described_class).to receive(:specs_finished?).and_return(true) }

    it 'renames the tmp data to the permanent key result' do
      allow(splitter).to receive(:rename)

      described_class.after_suite

      expect(splitter).to have_received(:rename)
    end
  end
end
