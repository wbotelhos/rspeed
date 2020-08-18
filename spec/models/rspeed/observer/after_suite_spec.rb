# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Observer, '.after_suite' do
  before { clean_csv_file }

  it 'rewrites csv files in desc order' do
    File.open('rspeed.csv', 'a') do |file|
      file.write(['3.0,3_spec.rb', '1.0,1_spec.rb', '2.0,2_spec.rb'].join("\n"))
    end

    described_class.after_suite

    result = ['3.0,3_spec.rb', '2.0,2_spec.rb', '1.0,1_spec.rb'].join("\n")

    expect(File.open('rspeed.csv').read).to eq "#{result}\n"
  end
end
