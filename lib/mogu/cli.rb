# frozen_string_literal: true

require 'thor'

module Mogu
  class CLI < Thor
    desc 'gem', 'Add gems to rails projects'
    def gem
      Mogu::GemCommand.new.run
    end

    desc 'new', 'Create rails projects interactively'
    def new
      Mogu::NewCommand.new.run
    end

    desc 'version', 'Display mogu version'
    def version
      puts Mogu::VERSION
    end
  end
end
