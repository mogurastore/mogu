# frozen_string_literal: true

RSpec.describe Mogu::GemCommand do
  describe '#run' do
    let(:command) { described_class.new }
    let(:gems) { %w[brakeman solargraph rspec rubocop] }
    let(:tempfile) { instance_double(Tempfile, rewind: nil, write: nil, path: 'tempfile_path') }

    before do
      allow(command).to receive(:ask_gems).and_return(gems)
      allow(Tempfile).to receive(:new).and_return(tempfile)
      allow(ENV).to receive(:store).with('LOCATION', 'tempfile_path')
      allow(Rails::Command).to receive(:invoke).with('app:template')

      command.run
    end

    it { expect(tempfile).to have_received(:write) }
    it { expect(tempfile).to have_received(:rewind) }
    it { expect(ENV).to have_received(:store).with('LOCATION', 'tempfile_path') }
    it { expect(Rails::Command).to have_received(:invoke).with('app:template') }
  end
end
