# frozen_string_literal: true

RSpec.describe RSpeed::Variable, 'PIPES_PATTERN' do
  it { expect(described_class::PIPES_PATTERN).to eq('rspeed_pipe_*') }
end
