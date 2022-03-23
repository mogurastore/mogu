# frozen_string_literal: true

require 'tty-prompt'

module Mogu
  class Prompt
    Result = Struct.new(:app_path, :customizes, :database, :javascript, :css, :gems, :template, keyword_init: true)

    def initialize
      @prompt = TTY::Prompt.new
      @result = Result.new(app_path: '', customizes: [], database: '', javascript: '', css: '', gems: [], template: nil)
    end

    def run
      @result.app_path = app_path
      @result.customizes = customizes

      @result.database = database if database?
      @result.javascript = javascript if javascript?
      @result.css = css if css?
      @result.gems = gems if gems?
      @result.template = Mogu::Template.create @result.gems if template?
    end

    def to_opt
      [
        @result.app_path,
        database? ? ['-d', @result.database] : [],
        javascript? ? ['-j', @result.javascript] : [],
        css? ? ['-c', @result.css] : [],
        rspec? ? %w[-T] : [],
        template? ? ['-m', @result.template.path] : []
      ].flatten
    end

    private

    def database?
      @result.customizes.include? 'database'
    end

    def javascript?
      @result.customizes.include? 'javascript'
    end

    def css?
      @result.customizes.include? 'css'
    end

    def gems?
      @result.customizes.include? 'gems'
    end

    def brakeman?
      @result.gems.include? 'brakeman'
    end

    def rspec?
      @result.gems.include? 'rspec'
    end

    def rubocop?
      @result.gems.include? 'rubocop'
    end

    def template?
      [brakeman?, rspec?, rubocop?].any?
    end

    def app_path
      @prompt.ask 'Please input app path', required: true
    end

    def css
      choices = %w[tailwind bootstrap bulma postcss sass]

      @prompt.select 'Choose css', choices
    end

    def customizes
      choices = [
        { name: 'database (Default: sqlite3)', value: 'database' },
        { name: 'javascript (Default: importmap)', value: 'javascript' },
        { name: 'css', value: 'css' },
        { name: 'gems', value: 'gems' }
      ]

      @prompt.multi_select 'Choose customizes', choices
    end

    def database
      choices = %w[sqlite3 mysql postgresql oracle sqlserver jdbcmysql jdbcsqlite3 jdbcpostgresql jdbc]

      @prompt.select 'Choose database', choices
    end

    def gems
      choices = %w[brakeman rspec rubocop]

      @prompt.multi_select 'Choose gems', choices
    end

    def javascript
      choices = %w[importmap webpack esbuild rollup]

      @prompt.select 'Choose javascript', choices
    end
  end
end
