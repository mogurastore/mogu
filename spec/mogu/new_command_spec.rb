# frozen_string_literal: true

RSpec.describe Mogu::NewCommand do
  describe '#run' do
    let(:command) { described_class.new }

    before do
      allow(command).to receive(:ask_app_path).and_return('app_path')
      allow(command).to receive(:confirm_is_api).and_return(is_api)
      allow(command).to receive(:ask_customizes).and_return(customizes)
      allow(command).to receive(:ask_database).and_return(%w[-d sqlite3])
      allow(command).to receive(:ask_javascript).and_return(%w[-j importmap])
      allow(command).to receive(:ask_css).and_return(%w[-c tailwind])
      allow(command).to receive(:ask_asset_pipeline).and_return(%w[-a propshaft])
      allow(command).to receive(:ask_skips).and_return(%w[--skip-test])
      allow(Rails::Command).to receive(:invoke)

      command.run
    end

    context 'with minimal customizes' do
      let(:is_api) { false }
      let(:customizes) { [] }
      let(:options) { %w[app_path] }

      it 'calls Rails::Command.invoke with minimal options' do
        expect(Rails::Command).to have_received(:invoke).with(:application, ['new', *options])
      end
    end

    context 'with api mode' do
      let(:is_api) { true }
      let(:customizes) { [] }
      let(:options) { %w[app_path --api] }

      it 'calls Rails::Command.invoke with api options' do
        expect(Rails::Command).to have_received(:invoke).with(:application, ['new', *options])
      end
    end

    context 'with full customizes' do
      let(:is_api) { false }
      let(:customizes) { %w[database javascript css asset_pipeline skips] }
      let(:options) { %w[app_path -d sqlite3 -j importmap -c tailwind -a propshaft --skip-test] }

      it 'calls Rails::Command.invoke with full options' do
        expect(Rails::Command).to have_received(:invoke).with(:application, ['new', *options])
      end
    end
  end
end
