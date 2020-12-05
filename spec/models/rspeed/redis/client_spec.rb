# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.client' do
  it 'returns a redis client' do
    expect(described_class.client.class).to eq(Redis)
  end
end
