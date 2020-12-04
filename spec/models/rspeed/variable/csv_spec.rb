# frozen_string_literal: true

RSpec.describe RSpeed::Variable, 'CSV' do
  it { expect(described_class::CSV).to eq('rspeed.csv') }
end
