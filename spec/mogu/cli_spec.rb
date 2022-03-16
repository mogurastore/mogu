# frozen_string_literal: true

RSpec.describe Mogu::CLI do
  describe '#start' do
    subject { described_class.new }

    let(:args) { %w[new app_path -d sqlite3 -j importmap -c tailwind -T -m template] }

    let(:prompt) do
      double(
        :prompt,
        app_path: 'app_path',
        customizes: %w[database javascript css gems],
        database: 'sqlite3',
        javascript: 'importmap',
        css: 'tailwind',
        gems: %w[rspec]
      )
    end

    let(:template) { double(:template, file: double(:file, path: 'template'), write: nil) }

    before do
      allow(subject).to receive(:prompt).and_return(prompt)
      allow(Mogu::Template).to receive(:new).and_return(template)
    end

    it do
      expect(Rails::Command).to receive(:invoke).with(:application, args)

      subject.start
    end
  end
end
