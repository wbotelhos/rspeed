# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.after_suite' do
  let!(:splitter) { instance_double('RSpeed::Splitter') }

  before do
    allow(RSpeed::Splitter).to receive(:new).and_return(splitter)
    allow(splitter).to receive(:append)
    allow(described_class).to receive(:pipe_done)
  end

  it 'appends the time result on tmp key' do
    described_class.after_suite

    expect(splitter).to have_received(:append)
  end

  it 'executes the pipe done' do
    described_class.after_suite

    expect(described_class).to have_received(:pipe_done)
  end
end
