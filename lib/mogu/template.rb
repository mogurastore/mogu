# frozen_string_literal: true

require 'tempfile'

module Mogu
  class Template
    class << self
      def create(gems)
        template = new
        template.write gems

        template
      end
    end

    def initialize
      @file = Tempfile.new
    end

    def path
      @file.path
    end

    def write(gems)
      @file.write brakeman_code if gems.include? 'brakeman'
      @file.write rspec_code if gems.include? 'rspec'
      @file.write rubocop_code if gems.include? 'rubocop'

      @file.rewind
    end

    private

    def brakeman_code
      <<~CODE
        gem 'brakeman', group: :development
      CODE
    end

    def rspec_code
      <<~CODE
        gem 'factory_bot_rails', group: %i[development test]
        gem 'rspec-rails', group: %i[development test]

        after_bundle do
          generate 'rspec:install'
        end
      CODE
    end

    def rubocop_code
      <<~CODE
        gem 'rubocop-rails', group: :development, require: false

        create_file '.rubocop.yml', <<~YML
          require:
            - rubocop-rails

          AllCops:
            NewCops: enable

          Rails:
            Enabled: true
        YML

        after_bundle do
          run 'rubocop --auto-gen-config'
        end
      CODE
    end
  end
end
