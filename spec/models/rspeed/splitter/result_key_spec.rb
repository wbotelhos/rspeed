# frozen_string_literal: true



RSpec.describe RSpeed::Splitter, '.result_key' do
  subject(:splitter) { described_class.new }

  context 'when key is not setted on env' do
    it 'returns default value' do
      expect(splitter.result_key).to eq 'rspeed'
    end
  end

  context 'when key is setted on env' do
    before { ENV['RESPEED_RESULT_KEY'] = 'result_customer' }

    it 'returns env value' do
      expect(splitter.result_key).to eq 'result_customer'
    end
  end
end
