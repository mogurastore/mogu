# frozen_string_literal: true

RSpec.describe Mogu::CLI do
  describe '#start' do
    subject { described_class.new }

    let(:args) { %w[new app_path -d sqlite3 -j importmap -c tailwind] }

    let(:prompt) do
      double(
        :prompt,
        app_path: 'app_path',
        customizes: %w[database javascript css],
        database: 'sqlite3',
        javascript: 'importmap',
        css: 'tailwind'
      )
    end

    before do
      allow(subject).to receive(:prompt).and_return(prompt)
    end

    it do
      expect(Rails::Command).to receive(:invoke).with(:application, args)

      subject.start
    end
  end
end
