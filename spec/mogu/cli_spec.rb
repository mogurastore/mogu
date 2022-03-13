# frozen_string_literal: true

require 'mogu/cli'

RSpec.describe Mogu::CLI do
  describe '#start' do
    subject { described_class.new }

    let(:args) { %w[new app_path -d sqlite3 -j importmap -c tailwind] }

    it do
      expect(subject).to receive(:prompt_app_path).and_return('app_path')
      expect(subject).to receive(:prompt_customizes).and_return(%w[database javascript css])
      expect(subject).to receive(:prompt_database).and_return('sqlite3')
      expect(subject).to receive(:prompt_javascript).and_return('importmap')
      expect(subject).to receive(:prompt_css).and_return('tailwind')
      expect(Rails::Command).to receive(:invoke).with(:application, args)

      subject.start
    end
  end
end
