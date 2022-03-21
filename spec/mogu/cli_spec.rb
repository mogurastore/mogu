# frozen_string_literal: true

RSpec.describe Mogu::CLI do
  describe '.start' do
    subject { described_class }

    let(:prompt) { double(:prompt, run: nil, to_opt: []) }

    before do
      allow(OptionParser).to receive(:getopts).and_return(params)
      allow(Mogu::Prompt).to receive(:new).and_return(prompt)
      allow(Rails::Command).to receive(:invoke)

      subject.start
    end

    context 'with v option' do
      let(:params) { { 'v' => true } }

      it { expect(prompt).not_to have_received(:run) }
      it { expect(Rails::Command).not_to have_received(:invoke) }
    end

    context 'without v option' do
      let(:params) { { 'v' => false } }

      it { expect(prompt).to have_received(:run) }
      it { expect(Rails::Command).to have_received(:invoke).with(:application, %w[new]) }
    end
  end
end
