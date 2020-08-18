# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Observer, '.after' do
  let!(:now) { Time.local(2020, 1, 1, 0, 0, 1) }
  let!(:clock) { class_double(RSpec::Core::Time, now: now) }
  let!(:metadata) { { file_path: 'file_path', line_number: 7, start_at: now - 1 } }
  let!(:example) { instance_double(RSpec::Core::Example, clock: clock, metadata: metadata) }

  before { clean_csv_file }

  it 'appends the time of example on csv file' do
    described_class.after(example)

    expect(File.open('rspeed.csv').read).to eq "1.0,file_path:7\n"
  end
end
