# frozen_string_literal: true

RSpec.describe Mogu::Template do
  describe '.create' do
    subject { described_class.create [] }

    let(:template) { double(:template, write: nil) }

    before do
      allow(described_class).to receive(:new).and_return(template)
    end

    it { is_expected.to eq template }

    it 'check method call' do
      subject
      expect(template).to have_received(:write)
    end
  end

  describe '#path' do
    subject { described_class.new.path }

    let(:tempfile) { Tempfile.new }

    before do
      allow(Tempfile).to receive(:new).and_return(tempfile)
    end

    it { is_expected.to eq tempfile.path }
  end

  describe '#write' do
    subject { described_class.new }

    after do
      subject.write gems
    end

    context 'when gems is empty' do
      let(:gems) { [] }

      it { expect(subject).not_to receive(:rspec_code) }
    end

    context 'when gems include brakeman' do
      let(:gems) { ['brakeman'] }

      it { expect(subject).to receive(:brakeman_code) }
    end

    context 'when gems include rspec' do
      let(:gems) { ['rspec'] }

      it { expect(subject).to receive(:rspec_code) }
    end

    context 'when gems include rubocop' do
      let(:gems) { ['rubocop'] }

      it { expect(subject).to receive(:rubocop_code) }
    end
  end
end
