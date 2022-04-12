# frozen_string_literal: true

RSpec.describe Mogu::NewCommand do
  describe '#run' do
    subject { Rails::Command }

    let(:command) { described_class.new }

    before do
      allow(command).to receive(:ask_app_path).and_return('app_path')
      allow(command).to receive(:confirm_is_api).and_return(is_api)
      allow(command).to receive(:ask_customizes).and_return(customizes)
      allow(command).to receive(:ask_database).and_return(%w[-d sqlite3])
      allow(command).to receive(:ask_javascript).and_return(%w[-j importmap])
      allow(command).to receive(:ask_css).and_return(%w[-c tailwind])
      allow(command).to receive(:ask_skips).and_return(%w[--skip-test])
      allow(Rails::Command).to receive(:invoke)

      command.run
    end

    context 'minimal customizes' do
      let(:is_api) { false }
      let(:customizes) { [] }
      let(:options) { %w[app_path] }

      it { is_expected.to have_received(:invoke).with(:application, ['new', *options]) }
    end

    context 'api mode' do
      let(:is_api) { true }
      let(:customizes) { [] }
      let(:options) { %w[app_path --api] }

      it { is_expected.to have_received(:invoke).with(:application, ['new', *options]) }
    end

    context 'full customizes' do
      let(:is_api) { false }
      let(:customizes) { %w[database javascript css skips] }
      let(:options) { %w[app_path -d sqlite3 -j importmap -c tailwind --skip-test] }

      it { is_expected.to have_received(:invoke).with(:application, ['new', *options]) }
    end
  end
end
