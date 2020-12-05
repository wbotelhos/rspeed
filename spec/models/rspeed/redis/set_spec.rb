# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.set' do
  it 'sets a key on redis' do
    described_class.set('key', 'value')

    expect(described_class.client.get('key')).to eq('value')
  end
end