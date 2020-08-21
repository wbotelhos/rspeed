# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Observer, '.before_suite' do
  before { clean_csv_file }

  it 'cleans the csv file' do
    File.open('rspeed.csv', 'a') { |file| file.write('content') }

    described_class.before_suite

    expect(File.open('rspeed.csv').read).to eq ''
  end
end