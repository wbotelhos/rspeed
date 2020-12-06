# frozen_string_literal: true

RSpec.describe RSpeed::Runner, '#run' do
  let!(:shell) { double('shell') }
  let!(:splitter) { instance_double('RSpeed::Splitter') }

  before { allow(RSpeed::Splitter).to receive(:new).and_return(splitter) }

  context 'when is a redundant run' do
    before { allow(splitter).to receive(:redundant_run?).and_return(true) }

    it 'aborts the run' do
      expect(described_class.run(shell)).to be(nil)
    end
  end

  context 'when is not a redundant run' do
    before do
      allow(splitter).to receive(:redundant_run?).and_return(false)
      allow(shell).to receive(:call)
      allow(splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
    end

    it 'run the pipe specs' do
      described_class.run(shell)

      expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
    end
  end
end
