# frozen_string_literal: true

RSpec.describe RSpeed::Differ, '#actual_files' do
  it 'returns all examples' do
    expect(described_class.actual_files(spec_path: './spec/fixtures/**/*_spec.rb')).to eq [
      './spec/fixtures/1_spec.rb:4',
      './spec/fixtures/1_spec.rb:6',
      './spec/fixtures/1_spec.rb:8',
      './spec/fixtures/2_spec.rb:4',
    ]
  end

  it 'does not raise when no file match' do
    expect(described_class.actual_files(spec_path: './spec/fixtures/**/*_missing.rb')).to eq []
  end

  it 'does not raise when file is empty' do
    expect(described_class.actual_files(spec_path: './spec/fixtures/**/empty.rb')).to eq []
  end
end
