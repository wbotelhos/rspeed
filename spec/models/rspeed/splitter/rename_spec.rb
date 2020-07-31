# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#rename' do
  subject(:splitter) { described_class.new }

  let!(:redis) { redis_object }

  before { redis.lpush 'rspeed_tmp', { file: '1_spec.rb', time: 1.0 }.to_json }

  it 'renames the key' do
    splitter.rename

    expect(redis.lrange('rspeed_tmp', 0, -1)).to eq []
    expect(redis.lrange('rspeed', 0, -1)).to     eq ['{"file":"1_spec.rb","time":1.0}']
  end
end
