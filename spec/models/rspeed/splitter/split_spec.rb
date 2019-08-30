# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '.split' do
  subject(:splitter) { described_class.new }

  before { allow(splitter).to receive(:pipes).and_return 3 }

  it 'splits the times between the pipes' do
    expect(splitter.split).to eq(
      rspeed_1: {
        files: [{ file: './spec/2_0_spec.rb', time: '2.0' }],
        number: 1,
        total: 2.0
      },

      rspeed_2: {
        files: [
          { file: './spec/1_5_spec.rb', time: '1.5' },
          { file: './spec/0_4_spec.rb', time: '0.4' },
          { file: './spec/0_2_spec.rb', time: '0.2' }
        ],

        number: 2,
        total: 1.5 + 0.4 + 0.2 # 1.5 -> 1.9 -> 2.1
      },

      rspeed_3: {
        files: [
          { file: './spec/1_1_spec.rb', time: '1.1' },
          { file: './spec/0_7_spec.rb', time: '0.7' },
          { file: './spec/0_3_spec.rb', time: '0.3' }
        ],

        number: 3,
        total: 1.1 + 0.7 + 0.3 # 1.1 -> 1.8 -> 2.1
      }
    )
  end
end
