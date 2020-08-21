# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#diff' do
  subject(:splitter) { described_class.new }

  let!(:redis) { redis_object }

  before do
    redis.lpush 'rspeed', { file: '1_spec.rb', time: 1 }.to_json
    redis.lpush 'rspeed', { file: '2_spec.rb', time: 2 }.to_json
    redis.lpush 'rspeed', { file: '3_spec.rb', time: 3 }.to_json

    allow(Dir).to receive(:[]).with('./spec/**/*_spec.rb').and_return %w[
      2_spec.rb
      3_spec.rb
      4_spec.rb
    ]
  end

  it 'removes removed specs and adds new spec and keeps keeped specs based on rspeed key values' do
    expect(splitter.diff).to eq [
      { file: '3_spec.rb', time: 3 },
      { file: '2_spec.rb', time: 2 },
      { file: '4_spec.rb', time: 0 },
    ]
  end
end
