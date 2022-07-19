# frozen_string_literal: true

module Rack
  class Idempotency
    class Store
      # Basic interface for a store
      class Base
        def read(_key)
          raise NotImplementedError
        end

        def write(_key, _value)
          raise NotImplementedError
        end
      end
    end
  end
end
