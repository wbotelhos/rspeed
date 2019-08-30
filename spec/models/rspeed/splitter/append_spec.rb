# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#append' do
  subject(:splitter) { described_class.new }

  it 'appends file and time on rspeed key' do
    splitter.append [{ file: '1_spec.rb', time: 1 }, { file: '2_spec.rb', time: 2 }]

    expect(splitter.get('rspeed')).to eq [
      '{"file":"2_spec.rb","time":2}',
      '{"file":"1_spec.rb","time":1}'
    ]
  end
end
