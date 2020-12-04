# frozen_string_literal: true

require 'json'
require 'support/fakeredis'

RSpec.describe RSpeed::Splitter, '#diff' do
  subject(:splitter) { described_class.new(specs_path: './spec/fixtures/*_spec.rb') }

  let!(:redis) { redis_object }

  before do
    redis.lpush 'rspeed', { file: './spec/fixtures/1_spec.rb:4', time: '1.4' }.to_json
    redis.lpush 'rspeed', { file: './spec/fixtures/1_spec.rb:6', time: '1.6' }.to_json
    redis.lpush 'rspeed', { file: './spec/fixtures/1_spec.rb:8', time: '1.8' }.to_json
    redis.lpush 'rspeed', { file: './spec/fixtures/2_spec.rb:4', time: '2.4' }.to_json
    redis.lpush 'rspeed', { file: './spec/fixtures/2_spec.rb:666', time: '6' }.to_json
    redis.lpush 'rspeed', { file: './spec/fixtures/x_spec.rb:1', time: 3 }.to_json

    File.open('spec/fixtures/new_spec.rb', 'a') { |file| file.write('it') }
  end

  after { delete_file('spec/fixtures/new_spec.rb') }

  it 'removes removed specs and adds new spec and keeps keeped specs based on rspeed key values' do
    expect(splitter.diff).to eq [
      { file: './spec/fixtures/2_spec.rb:4', time: '2.4' },
      { file: './spec/fixtures/1_spec.rb:8', time: '1.8' },
      { file: './spec/fixtures/1_spec.rb:6', time: '1.6' },
      { file: './spec/fixtures/1_spec.rb:4', time: '1.4' },
      { file: './spec/fixtures/new_spec.rb:1', time: 0 },
    ]
  end
end
