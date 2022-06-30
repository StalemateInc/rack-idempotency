# frozen_string_literal: true

require 'digest'

module Rack
  class Idempotency
    class RequestStorage
      SAFE_METHODS = %w[GET HEAD OPTIONS TRACE PUT DELETE]

      def initialize(store, request)
        @store   = store
        @request = request
      end

      def read
        return if SAFE_METHODS.include?(request.request_method) || request.idempotency_key.nil?

        stored = store.read(key)
        JSON.parse(stored) if stored
      end

      def write(response)
        return if SAFE_METHODS.include?(request.request_method) || request.idempotency_key.nil?

        store.write(key, response.to_json)
      end

      private

      attr_reader :request, :store

      def key
        Digest::SHA256.hexdigest(hashed_structure.to_s)
      end

      def hashed_structure
        [
          request.idempotency_key,
          request.env.reject { |key, _value| key.start_with?('HTTP_') || key.start_with?('rack.') },
          request.body.read
        ]
      end
    end
  end
end
