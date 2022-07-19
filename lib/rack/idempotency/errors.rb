# frozen_string_literal: true

module Rack
  class Idempotency
    # For all errors
    class Error < RuntimeError
      attr_reader :env

      def initialize(env)
        @env = env
      end
    end
    
    class InsecureKeyError < Error; end
  end
end
