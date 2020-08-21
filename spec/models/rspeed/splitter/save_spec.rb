# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '.save' do
  subject(:splitter) { described_class.new }

  let!(:redis) { redis_object }

  before do
    allow(splitter).to receive(:pipes).and_return(3)

    allow(splitter).to receive(:diff).and_return([
      { file: "./spec/0_2_spec.rb", time: '0.2' },
      { file: "./spec/0_3_spec.rb", time: '0.3' },
      { file: "./spec/0_4_spec.rb", time: '0.4' },
      { file: "./spec/0_7_spec.rb", time: '0.7' },
      { file: "./spec/1_1_spec.rb", time: '1.1' },
      { file: "./spec/1_5_spec.rb", time: '1.5' },
      { file: "./spec/2_0_spec.rb", time: '2.0' },
    ])
  end

  it 'saves the data on redis' do
    splitter.save

    expect(redis.keys('*')).to eq %w[rspeed_1 rspeed_2 rspeed_3]

    expect(JSON.parse(redis.get('rspeed_1'), symbolize_names: true)).to eq(
      files: [{ file: './spec/2_0_spec.rb', time: 2.0 }],
      number: 1,
      total: 2.0
    )

    expect(JSON.parse(redis.get('rspeed_2'), symbolize_names: true)).to eq(
      files: [
        { file: './spec/1_5_spec.rb', time: 1.5 },
        { file: './spec/0_4_spec.rb', time: 0.4 },
        { file: './spec/0_2_spec.rb', time: 0.2 }
      ],

      number: 2,
      total: 1.5 + 0.4 + 0.2
    )

    expect(JSON.parse(redis.get('rspeed_3'), symbolize_names: true)).to eq(
      files: [
        { file: './spec/1_1_spec.rb', time: 1.1 },
        { file: './spec/0_7_spec.rb', time: 0.7 },
        { file: './spec/0_3_spec.rb', time: 0.3 }
      ],

      number: 3,
      total: 1.1 + 0.7 + 0.3
    )
  end
end
