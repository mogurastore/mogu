# frozen_string_literal: true

require 'rails/command'

module Mogu
  class CLI
    attr_reader :prompt

    def initialize
      @prompt = Mogu::Prompt.new
    end

    def start
      app_path = prompt.app_path
      customizes = prompt.customizes
      args = build_args(customizes)

      Rails::Command.invoke :application, ['new', app_path, *args]
    end

    private

    def build_args(customizes)
      customizes.flat_map do |customize|
        case customize
        when 'database' then ['-d', prompt.database]
        when 'javascript' then ['-j', prompt.javascript]
        when 'css' then ['-c', prompt.css]
        when 'gems'
          gems = prompt.gems

          if gems.include? 'rspec'
            template = Mogu::Template.new
            template.write gems

            ['-T', '-m', template.file.path]
          else
            []
          end
        end
      end
    end
  end
end
