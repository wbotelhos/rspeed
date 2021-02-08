# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Differ, '#final_diff' do
  let!(:redis) { redis_object }

  before do
    redis.rpush('rspeed_previous', { file: './spec/fixtures/1_spec.rb:1', time: 1.1 }.to_json)
    redis.rpush('rspeed_previous', { file: './spec/fixtures/2_spec.rb:2', time: 2.2 }.to_json)
    redis.rpush('rspeed_previous', { file: './spec/fixtures/3_spec.rb:3', time: 3.3 }.to_json)
    redis.rpush('rspeed_previous', { file: './spec/fixtures/4_spec.rb:4', time: 4.4 }.to_json)

    redis.rpush('rspeed', { file: './spec/fixtures/1_spec.rb:1', time: 1.1 }.to_json)
    redis.rpush('rspeed', { file: './spec/fixtures/2_spec.rb:2', time: 2.2 }.to_json)
    redis.rpush('rspeed', { file: './spec/fixtures/5_spec.rb:5', time: 5.5 }.to_json)
    redis.rpush('rspeed', { file: './spec/fixtures/6_spec.rb:6', time: 6.6 }.to_json)
  end

  it 'returns the diff' do
    expect(described_class.final_diff).to eq(
      actual_files: [
        { file: './spec/fixtures/1_spec.rb:1', time: 1.1 },
        { file: './spec/fixtures/2_spec.rb:2', time: 2.2 },
        { file: './spec/fixtures/5_spec.rb:5', time: 5.5 },
        { file: './spec/fixtures/6_spec.rb:6', time: 6.6 },
      ],

      actual_time: 15.4,

      added_files: [
        { file: './spec/fixtures/5_spec.rb:5', time: 5.5 },
        { file: './spec/fixtures/6_spec.rb:6', time: 6.6 },
      ],

      added_time: 12.1,

      removed_files: [
        { file: './spec/fixtures/3_spec.rb:3', time: 3.3 },
        { file: './spec/fixtures/4_spec.rb:4', time: 4.4 },
      ],

      removed_time: 7.7
    )
  end
end
