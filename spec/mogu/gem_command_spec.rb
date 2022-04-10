# frozen_string_literal: true

RSpec.describe Mogu::GemCommand do
  describe '#run' do
    let(:gems) { %w[brakeman solargraph rspec rubocop] }
    let(:prompt) { TTY::Prompt.new }
    let(:tempfile) { double(:tempfile, rewind: nil, write: nil, path: 'tempfile_path') }

    before do
      allow(Tempfile).to receive(:new).and_return(tempfile)
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:multi_select).with('Choose gems', gems).and_return(gems)
      allow(ENV).to receive(:store).with('LOCATION', 'tempfile_path')
      allow(Rails::Command).to receive(:invoke).with('app:template')

      described_class.new.run
    end

    it { expect(prompt).to have_received(:multi_select).with('Choose gems', gems) }
    it { expect(tempfile).to have_received(:write) }
    it { expect(tempfile).to have_received(:rewind) }
    it { expect(ENV).to have_received(:store).with('LOCATION', 'tempfile_path') }
    it { expect(Rails::Command).to have_received(:invoke).with('app:template') }
  end
end
