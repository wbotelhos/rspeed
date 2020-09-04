# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Runner, '#run' do
  let!(:shell) { double('shell') }
  let!(:splitter) { instance_double('RSpeed::Splitter') }

  before do
    allow(RSpeed::Splitter).to receive(:new).and_return(splitter)

    allow(shell).to receive(:call)

    allow(splitter).to receive(:append)
  end

  context 'when is the first pipe' do
    before do
      allow(splitter).to receive(:first_pipe?).and_return(true)
      allow(splitter).to receive(:destroy)
    end

    context 'when has no result' do
      before do
        allow(splitter).to receive(:result?).and_return(false)
      end

      context 'when is the last pipe too' do
        before do
          allow(splitter).to receive(:last_pipe?).and_return(true)
          allow(splitter).to receive(:rename)
        end

        it 'destroyes rspeed_tmp, run all specs, appends the partial result and generates the final result' do
          described_class.run(shell)

          expect(splitter).to have_received(:destroy).with('rspeed_tmp')

          expect(shell).to have_received(:call).with('bundle exec rspec')

          expect(splitter).to have_received(:append)
          expect(splitter).to have_received(:rename)
        end
      end

      context 'when is not the last pipe' do
        before { allow(splitter).to receive(:last_pipe?).and_return(false) }

        it 'destroyes rspeed_tmp, run all specs, appends the partial result' do
          described_class.run(shell)

          expect(splitter).to have_received(:destroy).with('rspeed_tmp')

          expect(shell).to have_received(:call).with('bundle exec rspec')

          expect(splitter).to have_received(:append)
        end
      end
    end

    context 'when has result' do
      before do
        allow(splitter).to receive(:result?).and_return(true)
        allow(splitter).to receive(:save)
        allow(splitter).to receive(:pipe).and_return(1)
        allow(splitter).to receive(:get).with('rspeed_1').and_return([{ 'files' => [{ 'file' => 'spec.rb' }] }])
      end

      context 'when is the last pipe too' do
        before do
          allow(splitter).to receive(:last_pipe?).and_return(true)
          allow(splitter).to receive(:rename)
        end

        it 'destroyes rspeed_tmp, run the pipe specs, splits the saved result, appends the partial result and generates the final result' do
          described_class.run(shell)

          expect(splitter).to have_received(:destroy).with('rspeed_tmp')

          expect(shell).to have_received(:call).with('bundle exec rspec spec.rb')

          expect(splitter).to have_received(:append)
          expect(splitter).to have_received(:rename)
        end
      end

      context 'when is not the last pipe' do
        before do
          allow(splitter).to receive(:last_pipe?).and_return(false)
          allow(splitter).to receive(:rename)
        end

        it 'destroyes rspeed_tmp, run the pipe specs, splits the saved result, appends the partial result' do
          described_class.run(shell)

          expect(splitter).to have_received(:destroy).with('rspeed_tmp')

          expect(shell).to have_received(:call).with('bundle exec rspec spec.rb')

          expect(splitter).to have_received(:append)
        end
      end
    end
  end

  context 'when is not first pipe' do
    before { allow(splitter).to receive(:first_pipe?).and_return(false) }

    context 'when has no result' do
      before { allow(splitter).to receive(:result?).and_return(false) }

      context 'when is the last pipe' do
        before do
          allow(splitter).to receive(:last_pipe?).and_return(true)
          allow(splitter).to receive(:rename)
        end

        it 'run all specs, appends the partial result and generates the final result' do
          described_class.run(shell)

          expect(shell).to have_received(:call).with('bundle exec rspec')

          expect(splitter).to have_received(:append)
          expect(splitter).to have_received(:rename)
        end
      end

      context 'when is not the last pipe' do
        before { allow(splitter).to receive(:last_pipe?).and_return(false) }

        it 'run all specs, appends the partial result' do
          described_class.run(shell)

          expect(shell).to have_received(:call).with('bundle exec rspec')

          expect(splitter).to have_received(:append)
        end
      end
    end

    context 'when has result' do
      before do
        allow(splitter).to receive(:result?).and_return(true)
        allow(splitter).to receive(:save)
        allow(splitter).to receive(:pipe).and_return(1)
        allow(splitter).to receive(:get).with('rspeed_1').and_return([{ 'files' => [{ 'file' => 'spec.rb' }] }])
      end

      context 'when is the last pipe' do
        before do
          allow(splitter).to receive(:last_pipe?).and_return(true)
          allow(splitter).to receive(:rename)
        end

        it 'run the pipe specs, splits the saved result, appends the partial result and generates the final result' do
          described_class.run(shell)

          expect(shell).to have_received(:call).with('bundle exec rspec spec.rb')

          expect(splitter).to have_received(:append)
          expect(splitter).to have_received(:rename)
        end
      end

      context 'when is not the last pipe' do
        before do
          allow(splitter).to receive(:last_pipe?).and_return(false)
          allow(splitter).to receive(:rename)
        end

        it 'run the pipe specs, splits the saved result, appends the partial result' do
          described_class.run(shell)

          expect(shell).to have_received(:call).with('bundle exec rspec spec.rb')

          expect(splitter).to have_received(:append)
        end
      end
    end
  end
end
