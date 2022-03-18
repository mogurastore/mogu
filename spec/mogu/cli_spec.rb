# frozen_string_literal: true

RSpec.describe Mogu::CLI do
  describe '.start' do
    subject { described_class }

    let(:args) { %w[new] }
    let(:prompt) { double(:prompt, run: nil, to_opt: []) }

    before do
      allow(Mogu::Prompt).to receive(:new).and_return(prompt)
    end

    it do
      expect(prompt).to receive(:run)
      expect(Rails::Command).to receive(:invoke).with(:application, args)

      subject.start
    end
  end
end
