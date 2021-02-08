# frozen_string_literal: true

RSpec.describe RSpeed::Redis, '.version_the_result' do
  before { redis_object.rpush(RSpeed::Variable.result, true) }

  it 'renames the result to a previous result key' do
    described_class.version_the_result

    expect(redis_object.keys).to eq([RSpeed::Variable.previous_result])
  end

  context 'when already have a previous result' do
    before { redis_object.rpush(RSpeed::Variable.previous_result, true) }

    it 'overrides' do
      described_class.version_the_result

      expect(redis_object.keys).to eq([RSpeed::Variable.previous_result])
    end
  end
end
