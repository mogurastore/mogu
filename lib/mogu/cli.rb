# frozen_string_literal: true

require 'rails/command'
require 'thor'

module Mogu
  class CLI < Thor
    desc 'new', 'Create rails projects interactively'
    def new
      prompt = Mogu::Prompt.new
      prompt.run

      Rails::Command.invoke :application, ['new', *prompt.to_opt]
    end

    desc 'version', 'Display mogu version'
    def version
      puts Mogu::VERSION
    end
  end
end
