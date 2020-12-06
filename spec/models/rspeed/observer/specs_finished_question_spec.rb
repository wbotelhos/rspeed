# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Observer, '.specs_finished?' do
  before do
    RSpeed::Redis.set('rspeed_pipe_1', '1.0')

    allow(RSpeed::Env).to receive(:pipes).and_return(2)
  end

  context 'when the quantity of pipe result is not the same as the quantity of pipes' do
    it { expect(described_class.specs_finished?).to be(false) }
  end

  context 'when the quantity of pipe result is the same as the quantity of pipes' do
    before { RSpeed::Redis.set('rspeed_pipe_2', '2.0') }

    it { expect(described_class.specs_finished?).to be(true) }
  end
end
