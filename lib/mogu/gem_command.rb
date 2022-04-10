# frozen_string_literal: true

require 'erb'
require 'rails/command'
require 'tempfile'
require 'tty-prompt'

module Mogu
  class GemCommand
    def run
      erb = ERB.new File.read(File.expand_path('templates/gem.erb', __dir__))
      prompt = TTY::Prompt.new
      template = Tempfile.new

      gems = prompt.multi_select 'Choose gems', gem_choices
      template.write erb.result_with_hash(gems: gems)
      template.rewind

      ENV.store 'LOCATION', template.path

      Rails::Command.invoke 'app:template'
    end

    private

    def gem_choices
      %w[brakeman solargraph rspec rubocop]
    end
  end
end
