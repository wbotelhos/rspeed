# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.before_suite' do
  before { truncate_file }

  it 'cleans the csv file' do
    File.open('rspeed.csv', 'a') { |file| file.write('content') }

    described_class.before_suite

    expect(File.open('rspeed.csv').read).to eq ''
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
