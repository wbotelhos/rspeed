# frozen_string_literal: true

RSpec.describe RSpeed::Observer, '.after' do
  let!(:now) { Time.local(2020, 1, 1, 0, 0, 1) }
  let!(:clock) { class_double(RSpec::Core::Time, now: now) }
  let!(:metadata) { { file_path: 'file_path', line_number: 7, start_at: now - 1 } }
  let!(:example) { instance_double(RSpec::Core::Example, clock: clock, metadata: metadata) }

  before { truncate_profiles }

  it 'appends the file and time on pipe profile key' do
    described_class.after(example)

    expect(RSpeed::Redis.client.lrange(RSpeed::Variable.profile, 0, -1)).to eq [
      { file: 'file_path:7', time: 1.0 }.to_json,
    ]
  end
end
