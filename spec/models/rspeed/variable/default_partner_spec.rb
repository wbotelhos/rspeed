# frozen_string_literal: true

RSpec.describe RSpeed::Variable, 'DEFAULT_PATTERN' do
  it { expect(described_class::DEFAULT_PATTERN).to eq('rspeed_*') }
end
