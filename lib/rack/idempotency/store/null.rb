# frozen_string_literal: true

module Rack
  class Idempotency
    class Store
      # Most basic version of the store.  This class doesn't read or write.
      class Null < Base
        def read(_key); end

        def write(_key, _value); end
      end
    end
  end
end
