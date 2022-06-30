# frozen_string_literal: true

require 'redis'

module Rack
  class Idempotency
    # Stores idempotency information in a provided Redis instance.
    class RedisStore
      DEFAULT_TTL = 86400

      # @param client [Redis] A Redis client used to retrieve the requests.
      # @param ttl [#to_i, nil] Expiry duration in seconds.
      def initialize(client:, ttl: DEFAULT_TTL)
        @client = client
        @ttl = ttl.to_i
      end

      def read(key)
        client.get(key)
      end

      def write(key, value)
        if ttl.positive?
          client.setex(key, ttl, value)
        else
          client.set(key, value)
        end
      end

      private

      attr_reader :client, :ttl
    end
  end
end
