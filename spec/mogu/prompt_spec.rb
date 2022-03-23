# frozen_string_literal: true

RSpec.describe Mogu::Prompt do
  describe '#run' do
    subject { tty_prompt }

    let(:prompt) { Mogu::Prompt.new }
    let(:tty_prompt) { TTY::Prompt.new }

    let(:customizes) do
      [
        { name: 'database (Default: sqlite3)', value: 'database' },
        { name: 'javascript (Default: importmap)', value: 'javascript' },
        { name: 'css', value: 'css' },
        { name: 'gems', value: 'gems' }
      ]
    end

    let(:databases) do
      %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]
    end

    before do
      allow(TTY::Prompt).to receive(:new).and_return(tty_prompt)
      allow(Mogu::Template).to receive(:create)
      allow(subject).to receive(:ask)
      allow(subject).to receive(:select)
      allow(subject).to receive(:multi_select)
      allow(prompt).to receive(:database?).and_return(true)
      allow(prompt).to receive(:javascript?).and_return(true)
      allow(prompt).to receive(:css?).and_return(true)
      allow(prompt).to receive(:gems?).and_return(true)
      allow(prompt).to receive(:template?).and_return(true)

      prompt.run
    end

    it { is_expected.to have_received(:ask).with('Please input app path', required: true) }
    it { is_expected.to have_received(:multi_select).with('Choose customizes', customizes) }
    it {
      is_expected.to have_received(:select).with('Choose database', databases)
    }
    it { is_expected.to have_received(:select).with('Choose javascript', %w[importmap webpack esbuild rollup]) }
    it { is_expected.to have_received(:select).with('Choose css', %w[tailwind bootstrap bulma postcss sass]) }
    it { is_expected.to have_received(:multi_select).with('Choose gems', %w[brakeman rspec rubocop]) }
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
