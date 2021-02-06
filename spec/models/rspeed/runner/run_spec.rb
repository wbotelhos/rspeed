# frozen_string_literal: true

RSpec.describe RSpeed::Runner, '#run' do
  let!(:shell) { double('shell') }
  let!(:splitter) { instance_double('RSpeed::Splitter') }

  before do
    allow(shell).to receive(:call)
    allow(RSpeed::Splitter).to receive(:new).and_return(splitter)
    allow(RSpeed::Observer).to receive(:pipe_done)
  end

  context 'when has result' do
    before { allow(RSpeed::Redis).to receive(:result?).and_return(true) }

    context 'when is the first pipe' do
      before do
        allow(splitter).to receive(:first_pipe?).and_return(true)
        allow(splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
      end

      it 'runs the pipe specs' do
        described_class.run(shell)

        expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
      end

      it 'does not execute the pine done' do
        described_class.run(shell)

        expect(RSpeed::Observer).not_to have_received(:pipe_done)
      end
    end

    context 'when is not the first pipe' do
      before do
        allow(splitter).to receive(:first_pipe?).and_return(false)
        allow(splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
      end

      it 'runs the pipe specs' do
        described_class.run(shell)

        expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
      end

      it 'does not execute the pine done' do
        described_class.run(shell)

        expect(RSpeed::Observer).not_to have_received(:pipe_done)
      end
    end
  end

  context 'when has no result' do
    before do
      allow(splitter).to receive(:first_pipe?).and_return(false)
      allow(splitter).to receive(:pipe_files).and_return('spec_1.rb spec_2.rb')
    end

    context 'when is the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(true) }

      it 'runs the pipe specs' do
        described_class.run(shell)

        expect(shell).to have_received(:call).with('bundle exec rspec spec_1.rb spec_2.rb')
      end

      it 'does not execute the pine done' do
        described_class.run(shell)

        expect(RSpeed::Observer).not_to have_received(:pipe_done)
      end
    end

    context 'when is not the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(false) }

      it 'does not run the pipe specs' do
        described_class.run(shell)

        expect(shell).not_to have_received(:call)
      end

      it 'executes the pine done' do
        described_class.run(shell)

        expect(RSpeed::Observer).to have_received(:pipe_done)
      end
    end
  end
end
