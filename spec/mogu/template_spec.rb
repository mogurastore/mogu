# frozen_string_literal: true

RSpec.describe Mogu::Template do
  describe '#write' do
    subject { described_class.new }

    after do
      subject.write gems
    end

    context 'when gems is empty' do
      let(:gems) { [] }

      it { expect(subject).not_to receive(:rspec_code) }
    end

    context 'when gems include rspec' do
      let(:gems) { ['rspec'] }

      it { expect(subject).to receive(:rspec_code) }
    end
  end
end
