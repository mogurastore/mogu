# frozen_string_literal: true

require 'rails/command'
require 'tty-prompt'

module Mogu
  class CLI
    attr_reader :prompt

    def start
      @prompt = TTY::Prompt.new

      app_path = prompt.ask('Please input app path', required: true)

      customizes = choose_customizes
      database = customizes.include?('database') ? choose_database : ''
      javascript = customizes.include?('javascript') ? choose_javascript : ''
      css = customizes.include?('css') ? choose_css : ''

      args = [
        'new',
        app_path,
        database.empty? ? [] : ['-d', database],
        javascript.empty? ? [] : ['-j', javascript],
        css.empty? ? [] : ['-c', css]
      ].flatten

      Rails::Command.invoke :application, args
    end

    private

    def choose_customizes
      prompt.multi_select 'Choose customizes' do |menu|
        menu.choice 'database'
        menu.choice 'javascript'
        menu.choice 'css'
      end
    end

    def choose_database
      prompt.select 'Choose database' do |menu|
        menu.choice 'sqlite3'
        menu.choice 'mysql'
        menu.choice 'postgresql'
        menu.choice 'oracle'
        menu.choice 'sqlserver'
        menu.choice 'jdbcmysql'
        menu.choice 'jdbcsqlite3'
        menu.choice 'jdbcpostgresql'
        menu.choice 'jdbc'
      end
    end

    def choose_javascript
      prompt.select 'Choose javascript' do |menu|
        menu.choice 'importmap'
        menu.choice 'webpack'
        menu.choice 'esbuild'
        menu.choice 'rollup'
      end
    end

    def choose_css
      prompt.select 'Choose css' do |menu|
        menu.choice 'tailwind'
        menu.choice 'bootstrap'
        menu.choice 'bulma'
        menu.choice 'postcss'
        menu.choice 'sass'
      end
    end
  end
end
