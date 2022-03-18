# frozen_string_literal: true

require 'rails/command'

module Mogu
  class CLI
    class << self
      def start
        prompt = Mogu::Prompt.new
        prompt.run

        Rails::Command.invoke :application, ['new', *prompt.to_opt]
      end
    end
  end
end
