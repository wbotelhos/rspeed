# frozen_string_literal: true

RSpec.describe RSpeed::Variable, '.name' do
  it { expect(described_class.name).to be('rspeed_name') }
end
