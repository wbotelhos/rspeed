# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.specs_finished?' do
  context 'when has no pipe flag key' do
    it { expect(described_class.specs_finished?).to be(false) }
  end

  context 'when has at least one pipe flag key' do
    before { described_class.set('rspeed:pipe_01', '1.0') }

    it { expect(described_class.specs_finished?).to be(true) }
  end
end
