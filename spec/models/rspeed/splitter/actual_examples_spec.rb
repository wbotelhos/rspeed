# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#actual_examples' do
  it 'returns all examples' do
    splitter = described_class.new(specs_path: 'spec/fixtures/**/*_spec.rb')

    expect(splitter.actual_examples).to eq [
      'spec/fixtures/1_spec.rb:4',
      'spec/fixtures/1_spec.rb:6',
      'spec/fixtures/1_spec.rb:8',
      'spec/fixtures/2_spec.rb:4',
    ]
  end

  it 'does not raise when no file match' do
    splitter = described_class.new(specs_path: 'spec/fixtures/**/*_missing.rb')

    expect(splitter.actual_examples).to eq []
  end

  it 'does not raise when file is empty' do
    splitter = described_class.new(specs_path: 'spec/fixtures/**/empty.rb')

    expect(splitter.actual_examples).to eq []
  end
end
