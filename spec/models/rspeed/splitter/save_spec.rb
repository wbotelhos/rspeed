# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '.save' do
  subject(:splitter) { described_class.new }

  let!(:number_of_pipes) { 3 }
  let!(:redis) { Redis.new db: 14, host: 'localhost', port: 6379 }

  it 'saves the data on redis' do
    splitter.save number_of_pipes

    expect(redis.keys('*')).to eq %w[rspeed_0 rspeed_1 rspeed_2]

    expect(JSON.parse(redis.get('rspeed_0'), symbolize_names: true)).to eq(
      files: [['2.0', './spec/2_0_spec.rb']],
      number: 0,
      total: 2.0
    )

    expect(JSON.parse(redis.get('rspeed_1'), symbolize_names: true)).to eq(
      files: [['1.5', './spec/1_5_spec.rb'], ['0.4', './spec/0_4_spec.rb'], ['0.2', './spec/0_2_spec.rb']],
      number: 1,
      total: 1.5 + 0.4 + 0.2
    )

    expect(JSON.parse(redis.get('rspeed_2'), symbolize_names: true)).to eq(
      files: [['1.1', './spec/1_1_spec.rb'], ['0.7', './spec/0_7_spec.rb'], ['0.3', './spec/0_3_spec.rb']],
      number: 2,
      total: 1.1 + 0.7 + 0.3
    )
  end
end
