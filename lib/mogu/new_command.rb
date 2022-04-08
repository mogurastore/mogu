# frozen_string_literal: true

require 'rails/command'
require 'tty-prompt'

module Mogu
  class NewCommand
    def run
      @prompt = TTY::Prompt.new

      @app_path = @prompt.ask 'Please input app path', required: true
      @is_api = @prompt.yes? 'Do you want api mode?', default: false
      @customizes = @prompt.multi_select 'Choose customizes', customize_choices

      @database = @prompt.select 'Choose database', database_choices if database?
      @javascript = @prompt.select 'Choose javascript', javascript_choices if javascript?
      @css = @prompt.select 'Choose css', css_choices if css?
      @gems = @prompt.multi_select 'Choose gems', gem_choices if gems?
      @template = Mogu::Template.create @gems if template?

      Rails::Command.invoke :application, ['new', *to_opt]
    end

    private

    def database?
      @customizes.include? 'database'
    end

    def javascript?
      @customizes.include? 'javascript'
    end

    def css?
      @customizes.include? 'css'
    end

    def gems?
      @customizes.include? 'gems'
    end

    def rspec?
      @gems.include? 'rspec'
    end

    def template?
      @gems.any?
    end

    def css_choices
      %w[tailwind bootstrap bulma postcss sass]
    end

    def customize_choices
      if @is_api
        [
          { name: 'database (Default: sqlite3)', value: 'database' },
          { name: 'gems', value: 'gems' }
        ]
      else
        [
          { name: 'database (Default: sqlite3)', value: 'database' },
          { name: 'javascript (Default: importmap)', value: 'javascript' },
          { name: 'css', value: 'css' },
          { name: 'gems', value: 'gems' }
        ]
      end
    end

    def database_choices
      %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]
    end

    def gem_choices
      %w[brakeman solargraph rspec rubocop]
    end

    def javascript_choices
      %w[importmap webpack esbuild rollup]
    end

    def to_opt
      [
        @app_path,
        @is_api ? ['--api'] : [],
        database? ? ['-d', @database] : [],
        javascript? ? ['-j', @javascript] : [],
        css? ? ['-c', @css] : [],
        rspec? ? %w[-T] : [],
        template? ? ['-m', @template.path] : []
      ].flatten
    end
  end
end
