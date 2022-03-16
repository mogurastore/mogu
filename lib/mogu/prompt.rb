# frozen_string_literal: true

require 'tty-prompt'

module Mogu
  class Prompt
    attr_reader :prompt

    def initialize
      @prompt = TTY::Prompt.new
    end

    def app_path
      prompt.ask 'Please input app path', required: true
    end

    def css
      choices = %w[tailwind bootstrap bulma postcss sass]

      prompt.select 'Choose css', choices
    end

    def customizes
      choices = %w[database javascript css gems]

      prompt.multi_select 'Choose customizes', choices
    end

    def database
      choices = %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]

      prompt.select 'Choose database', choices
    end

    def gems
      choices = %w[rspec]

      prompt.multi_select 'Choose gems', choices
    end

    def javascript
      choices = %w[importmap webpack esbuild rollup]

      prompt.select 'Choose javascript', choices
    end
  end
end
