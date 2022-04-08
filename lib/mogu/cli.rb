# frozen_string_literal: true

require 'thor'

module Mogu
  class CLI < Thor
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
