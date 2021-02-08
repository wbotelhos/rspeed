# frozen_string_literal: true

RSpec.describe RSpeed::Database, '#list' do
  before do
    redis_object.rpush(RSpeed::Variable.result, { file: '1_spec.rb', time: 1.0 }.to_json)
    redis_object.rpush(RSpeed::Variable.result, { file: '2_spec.rb', time: 2.0 }.to_json)
  end

  it 'list and parse the given key' do
    expect(described_class.list(RSpeed::Variable.result)).to eq [
      { file: '1_spec.rb', time: 1.0 },
      { file: '2_spec.rb', time: 2.0 },
    ]
  end
end
