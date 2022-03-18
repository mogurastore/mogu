# frozen_string_literal: true

require 'tempfile'

module Mogu
  class Template
    attr_reader :file

    class << self
      def create(gems)
        template = new
        template.write gems

        template
      end
    end

    def initialize
      @file = Tempfile.create
    end

    def write(gems)
      file.write rspec_code if gems.include? 'rspec'

      file.rewind
    end

    private

    def rspec_code
      <<~CODE
        gem_group :development, :test do
          gem 'factory_bot_rails'
          gem 'rspec-rails'
        end

        after_bundle do
          generate 'rspec:install'
        end
      CODE
    end
  end
end
