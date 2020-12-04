# frozen_string_literal: true

require 'json'
require 'support/fakeredis'

RSpec.describe RSpeed::Splitter, '#append' do
  subject(:splitter) { described_class.new }

  it 'appends file and time on rspeed key' do
    splitter.append [[1, '1_spec.rb'], [2, '2_spec.rb']]

    expect(splitter.get('rspeed_tmp')).to eq [
      '{"file":"2_spec.rb","time":2.0}',
      '{"file":"1_spec.rb","time":1.0}',
    ]
  end

  context 'when files is not given' do
    before do
      truncate_file
      populate_csv_file
    end

    it 'read csv and append file and time on rspeed key' do
      splitter.append

      expect(splitter.get('rspeed_tmp')).to eq [
        '{"file":"./spec/0_2_spec.rb","time":0.2}',
        '{"file":"./spec/0_3_spec.rb","time":0.3}',
        '{"file":"./spec/0_4_spec.rb","time":0.4}',
        '{"file":"./spec/0_7_spec.rb","time":0.7}',
        '{"file":"./spec/1_1_spec.rb","time":1.1}',
        '{"file":"./spec/1_5_spec.rb","time":1.5}',
        '{"file":"./spec/2_0_spec.rb","time":2.0}',
      ]
    end
  end
end
