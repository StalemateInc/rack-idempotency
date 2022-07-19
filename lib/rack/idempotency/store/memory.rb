# frozen_string_literal: true

module Rack
  class Idempotency
    class Store
      # Stores idempotency information in a Hash.
      class Memory < Base
        def initialize
          @store = {}
          super
        end

        def read(key)
          store[key]
        end

        def write(key, value)
          store[key] = value
        end

        private

        attr_reader :store
      end
    end
  end
end
