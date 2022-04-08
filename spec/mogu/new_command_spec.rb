# frozen_string_literal: true

RSpec.describe Mogu::NewCommand do
  describe '#run' do
    subject { prompt }

    let(:command) { described_class.new }
    let(:prompt) { TTY::Prompt.new }

    let(:databases) do
      %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]
    end

    let(:gems) { %w[brakeman solargraph rspec rubocop] }

    before do
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(Rails::Command).to receive(:invoke)
      allow(subject).to receive(:ask)
      allow(subject).to receive(:yes?).with('Do you want api mode?', default: false).and_return(is_api)
      allow(subject).to receive(:select)
      allow(subject).to receive(:multi_select).with('Choose customizes', customizes_choices).and_return(customizes)
      allow(subject).to receive(:multi_select).with('Choose gems', gems).and_return(gems)

      command.run
    end

    shared_examples 'check common method call' do
      it { is_expected.to have_received(:ask).with('Please input app path', required: true) }
      it { is_expected.to have_received(:yes?).with('Do you want api mode?', default: false) }
      it { is_expected.to have_received(:multi_select).with('Choose customizes', customizes_choices) }
      it { is_expected.to have_received(:select).with('Choose database', databases) }
      it { is_expected.to have_received(:multi_select).with('Choose gems', gems) }
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
end
