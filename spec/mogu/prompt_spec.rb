# frozen_string_literal: true

RSpec.describe Mogu::Prompt do
  describe '#run' do
    subject { described_class.new }

    let(:template) { Mogu::Template.new }

    before do
      allow(subject).to receive(:app_path).and_return('app_path')
      allow(subject).to receive(:customizes).and_return(%w[database javascript css gems])
      allow(subject).to receive(:database).and_return('database')
      allow(subject).to receive(:javascript).and_return('javascript')
      allow(subject).to receive(:css).and_return('css')
      allow(subject).to receive(:gems).and_return(%w[brakeman rspec])
      allow(Mogu::Template).to receive(:create).and_return(template)
    end

    context 'before method execution' do
      let(:expected) do
        { app_path: '', customizes: [], database: '', javascript: '', css: '', gems: [], template: nil }
      end

      it { expect(subject.result.to_h).to eq expected }
    end

    context 'after method execution' do
      before { subject.run }

      let(:expected) do
        {
          app_path: 'app_path',
          customizes: %w[database javascript css gems],
          database: 'database',
          javascript: 'javascript',
          css: 'css',
          gems: %w[brakeman rspec],
          template: template
        }
      end

      it { expect(subject.result.to_h).to eq expected }
    end
  end

  describe '#to_opt' do
    subject { described_class.new }

    let(:template) { Mogu::Template.new }

    before do
      subject.result.app_path = 'app_path'
    end

    context 'only app_path ' do
      it { expect(subject.to_opt).to eq ['app_path'] }
    end

    context 'with base options ' do
      before do
        subject.result.customizes = %w[database javascript css]
        subject.result.database = 'database'
        subject.result.javascript = 'javascript'
        subject.result.css = 'css'
      end

      it { expect(subject.to_opt).to eq %w[app_path -d database -j javascript -c css] }
    end

    context 'with brakeman' do
      before do
        subject.result.customizes = %w[gems]
        subject.result.gems = %w[brakeman]
        subject.result.template = template
      end

      it { expect(subject.to_opt).to eq ['app_path', '-m', template.file.path] }
    end

    context 'with rspec' do
      before do
        subject.result.customizes = %w[gems]
        subject.result.gems = %w[rspec]
        subject.result.template = template
      end

      it { expect(subject.to_opt).to eq ['app_path', '-T', '-m', template.file.path] }
    end

    context 'with rubocop' do
      before do
        subject.result.customizes = %w[gems]
        subject.result.gems = %w[rubocop]
        subject.result.template = template
      end

      it { expect(subject.to_opt).to eq ['app_path', '-m', template.file.path] }
    end
  end
end
