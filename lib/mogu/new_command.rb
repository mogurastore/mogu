# frozen_string_literal: true

require 'cli/ui'
require 'rails/command'

module Mogu
  class NewCommand
    def run
      @app_path = ask_app_path
      @is_api = confirm_is_api
      customizes = ask_customizes

      @database = customizes.include?('database') ? ask_database : []
      @javascript = customizes.include?('javascript') ? ask_javascript : []
      @css = customizes.include?('css') ? ask_css : []
      @skips = customizes.include?('skips') ? ask_skips : []

      Rails::Command.invoke :application, ['new', *to_opt]
    end

    private

    def ask_app_path
      ::CLI::UI::Prompt.ask 'Please input app path', allow_empty: false
    end

    def confirm_is_api
      ::CLI::UI::Prompt.confirm 'Do you want api mode?', default: false
    end

    def ask_customizes
      ::CLI::UI::Prompt.ask 'Choose customizes', multiple: true do |handler|
        handler.option('database (Default: sqlite3)') { 'database' }

        unless @is_api
          handler.option('javascript (Default: importmap)') { 'javascript' }
          handler.option('css') { 'css' }
        end

        handler.option('skips') { 'skips' }
      end
    end

    def ask_database
      options = %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]

      ::CLI::UI::Prompt.ask 'Choose database' do |handler|
        options.each do |option|
          handler.option(option) { |s| ['-d', s] }
        end
      end
    end

    def ask_javascript
      options = %w[importmap webpack esbuild rollup]

      ::CLI::UI::Prompt.ask 'Choose javascript' do |handler|
        options.each do |option|
          handler.option(option) { |s| ['-j', s] }
        end
      end
    end

    def ask_css
      options = %w[tailwind bootstrap bulma postcss sass]

      ::CLI::UI::Prompt.ask 'Choose css' do |handler|
        options.each do |option|
          handler.option(option) { |s| ['-c', s] }
        end
      end
    end

    def ask_skips
      ::CLI::UI::Prompt.ask 'Choose skips', multiple: true do |handler|
        handler.option('test') { '--skip-test' }
      end
    end

    def to_opt
      [
        @app_path,
        @is_api ? '--api' : [],
        @database,
        @javascript,
        @css,
        *@skips
      ].flatten
    end
  end
end
