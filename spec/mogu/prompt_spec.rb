# frozen_string_literal: true

RSpec.describe Mogu::Prompt do
  describe '#run' do
    subject { described_class.new }

    before do
      allow(subject).to receive(:database?).and_return(true)
      allow(subject).to receive(:javascript?).and_return(true)
      allow(subject).to receive(:css?).and_return(true)
      allow(subject).to receive(:gems?).and_return(true)
      allow(subject).to receive(:template?).and_return(true)

      allow(subject).to receive(:app_path)
      allow(subject).to receive(:customizes)
      allow(subject).to receive(:database)
      allow(subject).to receive(:javascript)
      allow(subject).to receive(:css)
      allow(subject).to receive(:gems)
      allow(Mogu::Template).to receive(:create)

      subject.run
    end

    it { is_expected.to have_received(:app_path) }
    it { is_expected.to have_received(:customizes) }
    it { is_expected.to have_received(:database) }
    it { is_expected.to have_received(:javascript) }
    it { is_expected.to have_received(:css) }
    it { is_expected.to have_received(:gems) }

    it { expect(Mogu::Template).to have_received(:create) }
  end

  describe '#to_opt' do
    subject { described_class.new.to_opt }

    let(:result) do
      Mogu::Prompt::Result.new(
        app_path: 'app_path',
        customizes: customizes,
        database: 'sqlite3',
        javascript: 'importmap',
        css: 'tailwind',
        gems: gems,
        template: template
      )
    end

    let(:template) { Mogu::Template.new }

    before do
      allow(Mogu::Prompt::Result).to receive(:new).and_return(result)
    end

    context 'only app_path ' do
      let(:customizes) { [] }
      let(:gems) { [] }

      it { is_expected.to eq ['app_path'] }
    end

    context 'with base options ' do
      let(:customizes) { %w[database javascript css] }
      let(:gems) { [] }

      it { is_expected.to eq %w[app_path -d sqlite3 -j importmap -c tailwind] }
    end

    context 'with brakeman' do
      let(:customizes) { ['gems'] }
      let(:gems) { ['brakeman'] }

      it { is_expected.to eq ['app_path', '-m', template.path] }
    end

    context 'with rspec' do
      let(:customizes) { ['gems'] }
      let(:gems) { ['rspec'] }

      it { is_expected.to eq ['app_path', '-T', '-m', template.path] }
    end

    context 'with rubocop' do
      let(:customizes) { ['gems'] }
      let(:gems) { ['rubocop'] }

      it { is_expected.to eq ['app_path', '-m', template.path] }
    end
  end
end
