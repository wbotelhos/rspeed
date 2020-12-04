# frozen_string_literal: true



RSpec.describe RSpeed::Splitter, '.tmp_key' do
  subject(:splitter) { described_class.new }

  context 'when key is not setted on env' do
    it 'returns default value' do
      expect(splitter.tmp_key).to eq 'rspeed_tmp'
    end
  end

  context 'when key is setted on env' do
    before { ENV['RESPEED_TMP_KEY'] = 'result_customer' }

    it 'returns env value' do
      expect(splitter.tmp_key).to eq 'result_customer'
    end
  end
end
