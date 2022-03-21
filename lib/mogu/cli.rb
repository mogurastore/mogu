# frozen_string_literal: true

require 'optparse'
require 'rails/command'

module Mogu
  class CLI
    class << self
      def start
        params = OptionParser.getopts(ARGV, 'v')

        if params['v']
          puts "mogu #{Mogu::VERSION}"
        else
          prompt = Mogu::Prompt.new
          prompt.run

          Rails::Command.invoke :application, ['new', *prompt.to_opt]
        end
      end
    end
  end
end
