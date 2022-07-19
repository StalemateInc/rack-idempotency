# frozen_string_literal: true

require 'rack/utils'

module Rack
  class Idempotency
    class Response
      attr_reader :status, :headers, :body

      def initialize(status, headers, body)
        @status  = status.to_i
        @headers = Rack::Utils::HeaderHash.new(headers)
        @body    = body
      end

      def to_a
        [status, headers.to_hash, body.map(&:to_s)]
      end

      def to_json
        to_a.to_json
      end
    end
  end
end
