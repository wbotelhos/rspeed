# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#diff' do
  subject(:splitter) { described_class.new }

  let!(:redis) { Redis.new db: 14, host: 'localhost', port: 6379 }

  before do
    redis.set 'rspeed_0', { files: [[1, '1_spec.rb'], [2, '2_spec.rb']], number: 0, total: 3 }.to_json
    redis.set 'rspeed_1', { files: [[3, '3_spec.rb']], number: 1, total: 3 }.to_json

    allow(Dir).to receive(:[]).with('./spec/**/*_spec.rb').and_return %w[
      2_spec.rb
      3_spec.rb
      4_spec.rb
    ]
  end

  it 'returns only the actual specs with the news on first key' do
    expect(splitter.diff).to eq [['0.0', '4_spec.rb'], [2, '2_spec.rb'], [3, '3_spec.rb']]
  end
end
