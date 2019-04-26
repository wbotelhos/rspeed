# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Splitter, '.split' do
  subject(:splitter) { described_class.new }

  let!(:number_of_pipes) { 3 }

  it 'splits the times between the pipes' do
    expect(splitter.split(number_of_pipes)).to eq(
      rspeed_0: {
        files:  [[2.0, '2_0_spec.rb']],
        number: 0,
        total:  2.0
      },

      rspeed_1: {
        files:  [[1.5, '1_5_spec.rb'], [0.4, '0_4_spec.rb'], [0.2, '0_2_spec.rb']],
        number: 1,
        total:  1.5 + 0.4 + 0.2 # 1.5 -> 1.9 -> 2.1
      },

      rspeed_2: {
        files:  [[1.1, '1_1_spec.rb'], [0.7, '0_7_spec.rb'], [0.3, '0_3_spec.rb']],
        number: 2,
        total:  1.1 + 0.7 + 0.3 # 1.1 -> 1.8 -> 2.1
      }
    )
  end
end
