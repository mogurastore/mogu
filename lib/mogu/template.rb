# frozen_string_literal: true

require 'erb'
require 'tempfile'

module Mogu
  class Template
    class << self
      def create(gems)
        template = new
        template.write gems

        template
      end
    end

    def initialize
      @file = Tempfile.new
    end

    def path
      @file.path
    end

    def write(gems)
      erb = ERB.new File.read(File.expand_path('templates/gem.erb', __dir__))
      @file.write erb.result_with_hash(gems: gems)
      @file.rewind
    end
  end
end
