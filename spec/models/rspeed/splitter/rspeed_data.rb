# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#rspeed_data' do
  let!(:redis) { redis_object }

  before do
    redis.rpush('result', { file: '1_spec.rb', time: 1.0 }.to_json)
    redis.rpush('result', { file: '2_spec.rb', time: 2.0 }.to_json)
  end

  it 'returns the results data as json' do
    expect(described_class.new.rspeed_data('result')).to eq [
      '{"file":"1_spec.rb","time":1.0}',
      '{"file":"2_spec.rb","time":2.0}',
      '{"file":"3_spec.rb","time":3.0}',
    ]
  end
end
