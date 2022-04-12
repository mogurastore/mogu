# frozen_string_literal: true

require 'cli/ui'
require 'erb'
require 'rails/command'
require 'tempfile'

module Mogu
  class GemCommand
    def run
      erb = ERB.new File.read(File.expand_path('templates/gem.erb', __dir__))
      template = Tempfile.new

      gems = ask_gems
      template.write erb.result_with_hash(gems: gems)
      template.rewind

      ENV.store 'LOCATION', template.path

      Rails::Command.invoke 'app:template'
    end

    private

    def ask_gems
      options = %w[brakeman solargraph rspec rubocop]

      ::CLI::UI::Prompt.ask 'Choose gems', multiple: true, options: options
    end
  end
end
