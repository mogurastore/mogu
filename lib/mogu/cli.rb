# frozen_string_literal: true

require 'rails/command'
require 'tty-prompt'

module Mogu
  class CLI
    attr_reader :prompt

    def initialize
      @prompt = TTY::Prompt.new
    end

    def start
      app_path = prompt_app_path
      customizes = prompt_customizes
      args = build_args(customizes)

      Rails::Command.invoke :application, ['new', app_path, *args]
    end

    private

    def prompt_app_path
      prompt.ask 'Please input app path', required: true
    end

    def prompt_customizes
      choices = %w[database javascript css]

      prompt.multi_select 'Choose customizes', choices
    end

    def build_args(customizes)
      @args = customizes.flat_map do |customize|
        case customize
        when 'database' then ['-d', prompt_database]
        when 'javascript' then ['-j', prompt_javascript]
        when 'css' then ['-c', prompt_css]
        end
      end
    end

    def prompt_database
      choices = %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]

      prompt.select 'Choose database', choices
    end

    def prompt_javascript
      choices = %w[importmap webpack esbuild rollup]

      prompt.select 'Choose javascript', choices
    end

    def prompt_css
      choices = %w[tailwind bootstrap bulma postcss sass]

      prompt.select 'Choose css', choices
    end
  end
end
