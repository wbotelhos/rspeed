# frozen_string_literal: true

def delete_file(file_path)
  File.delete(file_path) if File.exist?(file_path)
end

def truncate_profiles
  RSpeed::Redis.destroy(pattern: RSpeed::Variable::PROFILE_PATTERN)
end

def populate_profiles
  data = [
    { file: './spec/2_0_spec.rb', time: 2.0 }.to_json,
    { file: './spec/1_5_spec.rb', time: 1.5 }.to_json,
    { file: './spec/1_1_spec.rb', time: 1.1 }.to_json,
    { file: './spec/0_7_spec.rb', time: 0.7 }.to_json,
    { file: './spec/0_4_spec.rb', time: 0.4 }.to_json,
    { file: './spec/0_3_spec.rb', time: 0.3 }.to_json,
    { file: './spec/0_2_spec.rb', time: 0.2 }.to_json,
  ]

  RSpeed::Splitter.append(items: data, key: RSpeed::Variable.profile)
end

def redis_object
  @redis_object ||= Redis.new(db: RSpeed::Env.db, host: RSpeed::Env.host)
end
