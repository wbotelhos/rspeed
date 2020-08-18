# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSpeed::Observer, '.before' do
  let!(:now) { Time.local(2020) }
  let!(:clock) { class_double(RSpec::Core::Time, now: now) }
  let!(:example) { instance_double(RSpec::Core::Example, clock: clock) }

  it 'saves the current time' do
    allow(example).to receive(:update_inherited_metadata)

    described_class.before(example)

    expect(example).to have_received(:update_inherited_metadata).with(start_at: now)
  end
end
