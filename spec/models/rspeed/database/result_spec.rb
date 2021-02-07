# frozen_string_literal: true

RSpec.describe RSpeed::Database, '#result' do
  let!(:redis) { redis_object }

  before do
    redis.rpush('rspeed', { file: '1_spec.rb', time: 1.0 }.to_json)
    redis.rpush('rspeed', { file: '2_spec.rb', time: 2.0 }.to_json)
  end

  it 'returns the results data as json' do
    expect(described_class.result).to eq [
      { file: '1_spec.rb', time: 1.0 },
      { file: '2_spec.rb', time: 2.0 },
    ]
  end
end
