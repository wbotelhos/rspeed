# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.before_suite' do
  before { truncate_profiles }

  it 'cleans the pipe profile' do
    RSpeed::Redis.client.lpush('rspeed_profile_1', { file: '1_spec.rb', time: 1 }.to_json)

    described_class.before_suite

    expect(RSpeed::Splitter.new.get('rspeed_profile_1')).to eq []
  end

  context 'when specs are not initiated yet' do
    before { allow(RSpeed::Redis).to receive(:specs_initiated?).and_return(false) }

    it 'destroyes the tmp result key' do
      RSpeed::Redis.client.lpush(RSpeed::Env.tmp_key, { file: 'file', time: 1.0 }.to_json)

      described_class.before_suite

      expect(RSpeed::Splitter.new.get(RSpeed::Variable.tmp)).to eq([])
    end
  end

  context 'when specs are already initiated' do
    before { allow(RSpeed::Redis).to receive(:specs_initiated?).and_return(true) }

    it 'does not destroy the tmp result key' do
      RSpeed::Redis.client.lpush(RSpeed::Env.tmp_key, { file: 'file', time: 1.0 }.to_json)

      described_class.before_suite

      expect(RSpeed::Splitter.new.get(RSpeed::Variable.tmp)).to eq(['{"file":"file","time":1.0}'])
    end
  end
end
