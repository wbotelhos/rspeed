# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#append' do
  subject(:splitter) { described_class.new }

  let!(:redis) { redis_object }

  it 'appends file and time on rspeed key' do
    splitter.append(
      items: [{ file: '1_spec.rb', time: 1 }.to_json, { file: '2_spec.rb', time: 2 }.to_json],
      key: 'rspeed'
    )

    expect(redis.lrange('rspeed', 0, -1)).to eq [
      '{"file":"1_spec.rb","time":1}',
      '{"file":"2_spec.rb","time":2}',
    ]
  end
end
