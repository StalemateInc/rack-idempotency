# frozen_string_literal: true

require 'rack/request'

module Rack
  class Idempotency    
    class Request < Rack::Request
      def idempotency_key
        get_header('HTTP_IDEMPOTENCY_KEY').tap do |key|
          unless key.nil? || key.match?(/^[\da-f]{8}-[\da-f]{4}-[1-5][\da-f]{3}-[89ab][\da-f]{3}-[\da-f]{12}$/i)
            raise InsecureKeyError.new(env), 'Idempotency-Key must be a valid UUID'
          end
        end
      end
    end
  end
end
