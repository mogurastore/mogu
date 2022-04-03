# frozen_string_literal: true

RSpec.describe Mogu::CLI do
  describe '#new' do
    subject { described_class.new }

    let(:prompt) { double(:prompt, run: nil, to_opt: []) }

    before do
      allow(Mogu::Prompt).to receive(:new).and_return(prompt)
      allow(Rails::Command).to receive(:invoke)

      subject.new
    end

    it { expect(prompt).to have_received(:run) }
    it { expect(Rails::Command).to have_received(:invoke).with(:application, %w[new]) }
  end
end
