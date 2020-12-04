# frozen_string_literal: true

RSpec.describe RSpeed::Variable, '.key' do
  it { expect(described_class.key(1)).to be(:rspeed_1) }
end
