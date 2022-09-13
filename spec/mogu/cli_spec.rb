# frozen_string_literal: true

RSpec.describe Mogu::CLI do
  describe '#new' do
    subject(:cli) { described_class.new }

    let(:command) { instance_double(Mogu::NewCommand, run: nil) }

    before do
      allow(Mogu::NewCommand).to receive(:new).and_return(command)

      cli.new
    end

    it { expect(command).to have_received(:run) }
  end
end
