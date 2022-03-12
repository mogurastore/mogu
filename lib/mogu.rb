# frozen_string_literal: true

require_relative "mogu/cli"
require_relative "mogu/version"

module Mogu; end

begin
  Mogu::CLI.new.start
rescue Interrupt
  puts
end
