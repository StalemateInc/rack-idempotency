# frozen_string_literal: true

require 'openssl/hmac'

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
        @key ||= "idempotency:#{digest}"
      end

      def digest
        digestable = "#{request.idempotency_key}:#{request.url}:#{request.params}"
        OpenSSL::HMAC.hexdigest('SHA256', 'idempotency', digestable)
      end
    end
  end
end
