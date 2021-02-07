# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.specs_finished?' do
  before do
    described_class.set('rspeed:pipe_01', '1.0')

    allow(RSpeed::Env).to receive(:pipes).and_return(2)
  end

  context 'when the quantity of pipe result is not the same as the quantity of pipes' do
    it { expect(described_class.specs_finished?).to be(false) }
  end

  context 'when the quantity of pipe result is the same as the quantity of pipes' do
    before { described_class.set('rspeed:pipe_02', '2.0') }

    it { expect(described_class.specs_finished?).to be(true) }
  end
end
