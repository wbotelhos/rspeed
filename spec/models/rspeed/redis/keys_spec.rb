# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.keys' do
  before do
    redis_object.set('custom_key_1', 'value_1')
    redis_object.set('custom_key_2', 'value_2')
    redis_object.set('custom_key_3', 'value_3')
  end

  it 'shows keys' do
    expect(described_class.keys(pattern: 'custom_key_*')).to eq %w[custom_key_1 custom_key_2 custom_key_3]
  end
end
