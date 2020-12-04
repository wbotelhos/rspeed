# frozen_string_literal: true

RSpec.describe RSpeed::Value, '.result_key' do
  context 'when key is not setted on env' do
    it 'returns default value' do
      expect(described_class.result_key).to eq 'rspeed'
    end
  end

  context 'when key is setted on env' do
    before { ENV['RESPEED_RESULT_KEY'] = 'result_customer' }

    it 'returns env value' do
      expect(described_class.result_key).to eq 'result_customer'
    end
  end
end
