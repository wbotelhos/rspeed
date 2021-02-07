# frozen_string_literal: true

RSpec.describe RSpeed::Runner, '#run' do
  let!(:shell) { double('shell') }

  before { allow(shell).to receive(:call) }

  context 'when has result' do
    before { allow(RSpeed::Redis).to receive(:result?).and_return(true) }

    context 'when is the first pipe' do
      before do
        allow(RSpeed::Splitter).to receive(:first_pipe?).and_return(true)
        allow(RSpeed::Splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
      end

      it 'runs the pipe specs' do
        described_class.run(shell)

        expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
      end
    end

    context 'when is not the first pipe' do
      before do
        allow(RSpeed::Splitter).to receive(:first_pipe?).and_return(false)
        allow(RSpeed::Splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
      end

      it 'runs the pipe specs' do
        described_class.run(shell)

        expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
      end
    end
  end

  context 'when has no result' do
    before do
      allow(RSpeed::Splitter).to receive(:first_pipe?).and_return(false)
      allow(RSpeed::Splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
    end

    context 'when is the first pipe' do
      before { allow(RSpeed::Splitter).to receive(:first_pipe?).and_return(true) }

      it 'runs the pipe specs' do
        described_class.run(shell)

        expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
      end
    end

    context 'when is not the first pipe' do
      before do
        allow(RSpeed::Splitter).to receive(:first_pipe?).and_return(false)
        allow(RSpeed::Observer).to receive(:after_suite)
      end

      it 'does not run the pipe specs' do
        described_class.run(shell)

        expect(shell).not_to have_received(:call)
      end

      it 'executes the after suite callback' do
        described_class.run(shell)

        expect(RSpeed::Observer).to have_received(:after_suite)
      end
    end
  end
end
