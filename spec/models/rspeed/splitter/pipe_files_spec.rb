# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#pipe_files' do
  let!(:shell) { double('shell') }
  let!(:splitter) { described_class.new }

  before { allow(splitter).to receive(:pipe).and_return(1) }

  context 'when has no result' do
    before { allow(splitter).to receive(:result?).and_return(false) }

    it { expect(splitter.pipe_files).to be(nil) }
  end

  context 'when has result' do
    before do
      allow(splitter).to receive(:result?).and_return(true)

      allow(splitter).to receive(:get)
        .with('rspeed_1')
        .and_return([{ 'files' => [{ 'file' => 'spec_1.rb' }, { 'file' => 'spec_2.rb' }] }])
    end

    context 'when is the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(true) }

      it 'saves the split and returns the pipe files' do
        allow(splitter).to receive(:save)

        expect(splitter.pipe_files).to eq 'spec_1.rb spec_2.rb'

        expect(splitter).to have_received(:save)
      end
    end

    context 'when is not the first pipe' do
      before { allow(splitter).to receive(:first_pipe?).and_return(false) }

      it 'returns the pipe files' do
        allow(splitter).to receive(:save)

        expect(splitter.pipe_files).to eq 'spec_1.rb spec_2.rb'
      end
    end
  end
end
