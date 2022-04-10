# frozen_string_literal: true

RSpec.describe Mogu::NewCommand do
  describe '#run' do
    subject { prompt }

    let(:command) { described_class.new }
    let(:prompt) { TTY::Prompt.new }

    let(:database_choices) do
      %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]
    end

    let(:javascript_choices) { %w[importmap webpack esbuild rollup] }
    let(:css_choices) { %w[tailwind bootstrap bulma postcss sass] }
    let(:skip_choices) { [{ name: 'test', value: '--skip-test' }] }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(Rails::Command).to receive(:invoke)
      allow(subject).to receive(:ask).with('Please input app path', required: true).and_return('app_path')
      allow(subject).to receive(:yes?).with('Do you want api mode?', default: false).and_return(is_api)
      allow(subject).to receive(:select).with('Choose database', database_choices).and_return('sqlite3')
      allow(subject).to receive(:select).with('Choose javascript', javascript_choices).and_return('importmap')
      allow(subject).to receive(:select).with('Choose css', css_choices).and_return('tailwind')
      allow(subject).to receive(:multi_select).with('Choose customizes', customize_choices).and_return(customizes)
      allow(subject).to receive(:multi_select).with('Choose skips', skip_choices).and_return(%w[--skip-test])

      command.run
    end

    shared_examples 'check common method call' do
      it { is_expected.to have_received(:ask).with('Please input app path', required: true) }
      it { is_expected.to have_received(:yes?).with('Do you want api mode?', default: false) }
      it { is_expected.to have_received(:multi_select).with('Choose customizes', customize_choices) }
      it { is_expected.to have_received(:select).with('Choose database', database_choices) }
      it { is_expected.to have_received(:multi_select).with('Choose skips', skip_choices) }
      it { expect(Rails::Command).to have_received(:invoke).with(:application, ['new', *options]) }
    end

    context 'when is_api is true' do
      let(:is_api) { true }
      let(:customize_choices) do
        [
          { name: 'database (Default: sqlite3)', value: 'database' },
          { name: 'skips', value: 'skips' }
        ]
      end
      let(:customizes) { %w[database skips] }
      let(:options) { ['app_path', '--api', '-d', 'sqlite3', '--skip-test'] }

      it_behaves_like 'check common method call'

      it { is_expected.not_to have_received(:select).with('Choose javascript', javascript_choices) }
      it { is_expected.not_to have_received(:select).with('Choose css', css_choices) }
    end

    context 'when is_api is false' do
      let(:is_api) { false }
      let(:customize_choices) do
        [
          { name: 'database (Default: sqlite3)', value: 'database' },
          { name: 'javascript (Default: importmap)', value: 'javascript' },
          { name: 'css', value: 'css' },
          { name: 'skips', value: 'skips' }
        ]
      end
      let(:customizes) { %w[database javascript css skips] }
      let(:options) do
        ['app_path', '-d', 'sqlite3', '-j', 'importmap', '-c', 'tailwind', '--skip-test']
      end

      it_behaves_like 'check common method call'

      it { is_expected.to have_received(:select).with('Choose javascript', javascript_choices) }
      it { is_expected.to have_received(:select).with('Choose css', css_choices) }
    end
  end
end
