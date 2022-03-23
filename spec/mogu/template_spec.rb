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

    before do
      allow(subject).to receive(:brakeman_code)
      allow(subject).to receive(:solargraph_code)
      allow(subject).to receive(:rspec_code)
      allow(subject).to receive(:rubocop_code)

      subject.write %w[brakeman solargraph rspec rubocop]
    end

    it { is_expected.to have_received(:brakeman_code) }
    it { is_expected.to have_received(:solargraph_code) }
    it { is_expected.to have_received(:rspec_code) }
    it { is_expected.to have_received(:rubocop_code) }
  end
end
