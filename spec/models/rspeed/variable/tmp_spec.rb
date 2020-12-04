# frozen_string_literal: true

RSpec.describe RSpeed::Variable, '.tmp' do
  it { expect(described_class.tmp).to eq('rspeed_tmp') }
end
