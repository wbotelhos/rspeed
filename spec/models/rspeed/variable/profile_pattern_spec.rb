# frozen_string_literal: true

RSpec.describe RSpeed::Variable, 'PROFILE_PATTERN' do
  it { expect(described_class::PROFILE_PATTERN).to eq('rspeed:profile_*') }
end
