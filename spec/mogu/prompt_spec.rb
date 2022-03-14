# frozen_string_literal: true

require 'mogu/prompt'

RSpec.describe Mogu::Prompt do
  subject { described_class.new }

  describe '#app_path' do
    it 'receive ask' do
      expect(subject.prompt).to receive(:ask)
      subject.app_path
    end
  end

  describe '#css' do
    it 'receive select' do
      expect(subject.prompt).to receive(:select)
      subject.css
    end
  end

  describe '#customizes' do
    it 'receive multi_select' do
      expect(subject.prompt).to receive(:multi_select)
      subject.customizes
    end
  end

  describe '#database' do
    it 'receive select' do
      expect(subject.prompt).to receive(:select)
      subject.database
    end
  end

  describe '#javascript' do
    it 'receive select' do
      expect(subject.prompt).to receive(:select)
      subject.javascript
    end
  end
end
