# frozen_string_literal: true

RSpec.describe RSpeed::Runner, '#run' do
  let!(:shell) { double('shell') }
  let!(:splitter) { instance_double('RSpeed::Splitter') }

  before do
    allow(shell).to receive(:call)
    allow(RSpeed::Splitter).to receive(:new).and_return(splitter)
    allow(RSpeed::Observer).to receive(:after_suite)
  end

  context 'when does not need warm' do
    before { allow(splitter).to receive(:need_warm?).and_return(false) }

    it 'does not run the specs' do
      described_class.run(shell)

      expect(shell).not_to have_received(:call)
    end

    it 'executes the after suite to complete the current pipe' do
      described_class.run(shell)

      expect(RSpeed::Observer).to have_received(:after_suite)
    end
  end

  context 'when need warm' do
    before do
      allow(splitter).to receive(:need_warm?).and_return(true)
      allow(splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
    end

    it 'run the pipe specs' do
      described_class.run(shell)

      expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
    end

    it 'does not execute the after suite to complete the current pipe' do
      described_class.run(shell)

      expect(RSpeed::Observer).not_to have_received(:after_suite)
    end
  end
end
