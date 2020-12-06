# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '#result?' do
  context 'when has no key rspeed on redis' do
    it { expect(described_class.result?).to be(false) }
  end

  context 'when has key rspeed on redis' do
    before { described_class.set('rspeed', { files: [[1, '1_spec.rb']], number: 0, total: 1 }.to_json) }

    it { expect(described_class.result?).to be(true) }
  end
end
