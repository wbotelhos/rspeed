# frozen_string_literal: true

require 'support/env_mock'

RSpec.describe RSpeed::Splitter, '#diff' do
  let!(:redis) { redis_object }

  before do
    redis.rpush 'rspeed', { file: './spec/fixtures/1_spec.rb:4', time: '1.4' }.to_json
    redis.rpush 'rspeed', { file: './spec/fixtures/1_spec.rb:6', time: '1.6' }.to_json
    redis.rpush 'rspeed', { file: './spec/fixtures/1_spec.rb:8', time: '1.8' }.to_json
    redis.rpush 'rspeed', { file: './spec/fixtures/2_spec.rb:4', time: '2.4' }.to_json
    redis.rpush 'rspeed', { file: './spec/fixtures/x_spec.rb:1', time: 3 }.to_json
    redis.rpush 'rspeed', { file: './spec/fixtures/2_spec.rb:666', time: '6' }.to_json

    File.open('spec/fixtures/new_spec.rb', 'a') { |file| file.write('it') }
  end

  after { delete_file('spec/fixtures/new_spec.rb') }

  it 'removes removed specs and adds new spec and keeps keeped specs based on rspeed key values' do
    EnvMock.mock(rspeed_spec_path: './spec/fixtures/*_spec.rb') do
      expect(described_class.diff).to eq [
        { file: './spec/fixtures/1_spec.rb:4', time: '1.4' },
        { file: './spec/fixtures/1_spec.rb:6', time: '1.6' },
        { file: './spec/fixtures/1_spec.rb:8', time: '1.8' },
        { file: './spec/fixtures/2_spec.rb:4', time: '2.4' },
        { file: './spec/fixtures/new_spec.rb:1', time: 0 },
      ]
    end
  end
end
