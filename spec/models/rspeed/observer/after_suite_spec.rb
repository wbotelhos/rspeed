# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.after' do
  let!(:splitter) { instance_double('RSpeed::Splitter') }

  before do
    allow(RSpeed::Splitter).to receive(:new).and_return(splitter)
    allow(splitter).to receive(:append)
  end

  context 'when all specs is not finished' do
    before { allow(RSpeed::Redis).to receive(:specs_finished?).and_return(false) }

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
    before do
      allow(RSpeed::Redis).to receive(:specs_finished?).and_return(true)
      allow(splitter).to receive(:rename)
      allow(RSpeed::Redis).to receive(:clean_pipes_flag)
    end

    it 'renames the tmp data to the permanent key result' do
      described_class.after_suite

      expect(splitter).to have_received(:rename)
    end

    it 'destroyes pipe finished flag keys' do
      described_class.after_suite

      expect(RSpeed::Redis).to have_received(:clean_pipes_flag)
    end
  end
end
