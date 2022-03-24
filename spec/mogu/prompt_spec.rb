# frozen_string_literal: true

RSpec.describe Mogu::Prompt do
  describe '#run' do
    subject { tty_prompt }

    let(:prompt) { Mogu::Prompt.new }
    let(:tty_prompt) { TTY::Prompt.new }

    let(:databases) do
      %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]
    end

    let(:gems) { %w[brakeman solargraph rspec rubocop] }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(tty_prompt)
      allow(Mogu::Template).to receive(:create)
      allow(subject).to receive(:ask)
      allow(subject).to receive(:yes?).with('Do you want api mode?', default: false).and_return(is_api)
      allow(subject).to receive(:select)
      allow(subject).to receive(:multi_select).with('Choose customizes', customizes_choices).and_return(customizes)
      allow(subject).to receive(:multi_select).with('Choose gems', gems).and_return(gems)

      prompt.run
    end

    shared_examples 'check common method call' do
      it { is_expected.to have_received(:ask).with('Please input app path', required: true) }
      it { is_expected.to have_received(:yes?).with('Do you want api mode?', default: false) }
      it { is_expected.to have_received(:multi_select).with('Choose customizes', customizes_choices) }
      it { is_expected.to have_received(:select).with('Choose database', databases) }
      it { is_expected.to have_received(:multi_select).with('Choose gems', gems) }
      it { expect(Mogu::Template).to have_received(:create) }
    end

    context 'when is_api is true' do
      let(:is_api) { true }
      let(:customizes_choices) do
        [
          { name: 'database (Default: sqlite3)', value: 'database' },
          { name: 'gems', value: 'gems' }
        ]
      end
      let(:customizes) { %w[database gems] }

      it_behaves_like 'check common method call'

      it { is_expected.not_to have_received(:select).with('Choose javascript', %w[importmap webpack esbuild rollup]) }
      it { is_expected.not_to have_received(:select).with('Choose css', %w[tailwind bootstrap bulma postcss sass]) }
    end

    context 'when is_api is false' do
      let(:is_api) { false }
      let(:customizes_choices) do
        [
          { name: 'database (Default: sqlite3)', value: 'database' },
          { name: 'javascript (Default: importmap)', value: 'javascript' },
          { name: 'css', value: 'css' },
          { name: 'gems', value: 'gems' }
        ]
      end
      let(:customizes) { %w[database javascript css gems] }

      it_behaves_like 'check common method call'

      it { is_expected.to have_received(:select).with('Choose javascript', %w[importmap webpack esbuild rollup]) }
      it { is_expected.to have_received(:select).with('Choose css', %w[tailwind bootstrap bulma postcss sass]) }
    end
  end

  describe '#to_opt' do
    subject { described_class.new.to_opt }

    let(:result) do
      Mogu::Prompt::Result.new(
        app_path: 'app_path',
        is_api: is_api,
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
      let(:is_api) { false }
      let(:customizes) { [] }
      let(:gems) { [] }

      it { is_expected.to eq ['app_path'] }
    end

    context 'with api options' do
      let(:is_api) { true }
      let(:customizes) { [] }
      let(:gems) { [] }

      it { is_expected.to eq %w[app_path --api] }
    end

    context 'with base options ' do
      let(:is_api) { false }
      let(:customizes) { %w[database javascript css] }
      let(:gems) { [] }

      it { is_expected.to eq %w[app_path -d sqlite3 -j importmap -c tailwind] }
    end

    context 'with brakeman' do
      let(:is_api) { false }
      let(:customizes) { ['gems'] }
      let(:gems) { ['brakeman'] }

      it { is_expected.to eq ['app_path', '-m', template.path] }
    end

    context 'with rspec' do
      let(:is_api) { false }
      let(:customizes) { ['gems'] }
      let(:gems) { ['rspec'] }

      it { is_expected.to eq ['app_path', '-T', '-m', template.path] }
    end

    context 'with rubocop' do
      let(:is_api) { false }
      let(:customizes) { ['gems'] }
      let(:gems) { ['rubocop'] }

      it { is_expected.to eq ['app_path', '-m', template.path] }
    end
  end
end
