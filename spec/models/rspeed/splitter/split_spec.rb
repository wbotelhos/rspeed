# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Splitter, '.split' do
  context 'when has no nil time' do
    let!(:unsorted_data) do
      [
        { file: './spec/1_5_spec.rb', time: 1.5 },
        { file: './spec/1_1_spec.rb', time: 1.1 },
        { file: './spec/0_7_spec.rb', time: 0.7 },
        { file: './spec/0_4_spec.rb', time: 0.4 },
        { file: './spec/0_3_spec.rb', time: 0.3 },
        { file: './spec/0_2_spec.rb', time: 0.2 },
        { file: './spec/2_0_spec.rb', time: 2.0 },
      ]
    end

    it 'splits the times between the pipes' do
      EnvMock.mock(rspeed_pipes: 3) do
        expect(described_class.split(data: unsorted_data)).to eq(
          rspeed_1: {
            files: [{ file: './spec/2_0_spec.rb', time: 2.0 }],
            number: 1,
            total: 2.0,
          },

          rspeed_2: {
            files: [
              { file: './spec/1_5_spec.rb', time: 1.5 },
              { file: './spec/0_4_spec.rb', time: 0.4 },
              { file: './spec/0_2_spec.rb', time: 0.2 },
            ],

            number: 2,
            total: 1.5 + 0.4 + 0.2, # 1.5 -> 1.9 -> 2.1
          },

          rspeed_3: {
            files: [
              { file: './spec/1_1_spec.rb', time: 1.1 },
              { file: './spec/0_7_spec.rb', time: 0.7 },
              { file: './spec/0_3_spec.rb', time: 0.3 },
            ],

            number: 3,
            total: 1.1 + 0.7 + 0.3, # 1.1 -> 1.8 -> 2.1
          }
        )
      end
    end
  end

  context 'when has nil time' do
    let!(:unsorted_data) do
      [
        { file: './spec/1_5_spec.rb', time: 1.5 },
        { file: './spec/1_1_spec.rb', time: 1.1 },
        { file: './spec/2_0_spec.rb', time: nil },
      ]
    end

    it 'uses zero as default' do
      EnvMock.mock(rspeed_pipes: 3) do
        expect(described_class.split(data: unsorted_data)).to eq(
          rspeed_1: {
            files: [{ file: './spec/1_5_spec.rb', time: 1.5 }],
            number: 1,
            total: 1.5,
          },

          rspeed_2: {
            files: [
              { file: './spec/1_1_spec.rb', time: 1.1 },
            ],

            number: 2,
            total: 1.1
          },

          rspeed_3: {
            files: [
              { file: './spec/2_0_spec.rb', time: 0.0 },
            ],

            number: 3,
            total: 0.0,
          }
        )
      end
    end
  end
end
