# frozen_string_literal: true

RSpec.describe RSpeed::Splitter, '#pipe_files' do
  context 'when has no result' do
    before { allow(RSpeed::Redis).to receive(:result?).and_return(false) }

    it { expect(described_class.pipe_files).to be(nil) }
  end

  context 'when has result' do
    before do
      allow(RSpeed::Redis).to receive(:result?).and_return(true)

      allow(described_class).to receive(:split).and_return(rspeed_1: { files: [{ file: 'spec_1.rb' }, { file: 'spec_2.rb' }] })
    end

    it 'returns the splitted pipe files' do
      expect(described_class.pipe_files).to eq('spec_1.rb spec_2.rb')
    end
  end
end
