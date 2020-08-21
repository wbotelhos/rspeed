# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Splitter, '#actual_examples' do
  subject(:splitter) { described_class.new }

  it 'returns all examples' do
    expect(splitter.actual_examples('spec/fixtures/**/*_spec.rb')).to eq [
      'spec/fixtures/1_spec.rb:4',
      'spec/fixtures/1_spec.rb:6',
      'spec/fixtures/1_spec.rb:8',
      'spec/fixtures/2_spec.rb:4',
    ]
  end
end
