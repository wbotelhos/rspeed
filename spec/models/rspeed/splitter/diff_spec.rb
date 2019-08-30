# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#diff' do
  subject(:splitter) { described_class.new }

  let!(:redis) { Redis.new db: 14, host: 'localhost', port: 6379 }

  before do
    redis.set 'rspeed', {
      files: [[1, '1_spec.rb'], [2, '2_spec.rb'], [3, '3_spec.rb']], number: 0, total: 6
    }.to_json

    allow(Dir).to receive(:[]).with('./spec/**/*_spec.rb').and_return %w[
      2_spec.rb
      3_spec.rb
      4_spec.rb
    ]
  end

  it 'removes removed specs and adds new spec and keeps keeped specs based on rspeed key values' do
    expect(splitter.diff).to eq [['0.0', '4_spec.rb'], [2, '2_spec.rb'], [3, '3_spec.rb']]
  end
end
