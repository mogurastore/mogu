# frozen_string_literal: true

RSpec.describe Mogu::CLI do
  describe '#new' do
    subject { described_class.new }

    let(:command) { double(:command, run: nil) }

    before do
      allow(Mogu::NewCommand).to receive(:new).and_return(command)

      subject.new
    end

    it { expect(command).to have_received(:run) }
  end
end
