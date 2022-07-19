# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::Idempotency do
  let(:app) { lambda { |_| [200, { 'Content-Type' => 'text/plain' }, [SecureRandom.uuid]] } }
  let(:request) { Rack::MockRequest.new(middleware) }
  let(:key) { SecureRandom.uuid }

  it 'has a version number' do
    expect(Rack::Idempotency::VERSION).not_to be_nil
  end

  shared_examples 'functioning idempotency store' do
    context 'without an idempotency key' do
      subject { request.post('/').body }

      it 'does not match any stored responses' do
        expect(subject).not_to be_nil
      end
    end

    context 'with insecure idempotency key' do
      subject { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => 'x') }

      it 'raises a Rack::Idempotency::InsecureKeyError' do
        expect { subject }.to raise_error(Rack::Idempotency::InsecureKeyError)
      end
    end

    context 'with an idempotency key' do
      subject { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => key).body }

      context 'with a successful request' do
        context 'on first request' do
          it 'does not match any stored responses' do
            expect(subject).not_to be_nil
          end
        end

        context 'on second request' do
          let(:original) { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => key).body }

          it 'matches the stored response from first request' do
            expect(subject).to eq(original)
          end
        end

        context 'on different request' do
          let(:different) { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => SecureRandom.uuid).body }

          it 'does not match any stored responses' do
            expect(subject).not_to eq(different)
          end
        end
      end

      context 'with a failed request' do
        let(:app) { lambda { |_| [500, { 'Content-Type' => 'text/plain' }, [SecureRandom.uuid]] } }

        context 'on first request' do
          it 'does not match any stored responses' do
            expect(subject).not_to be_nil
          end
        end

        context 'on second request' do
          let(:original) { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => key).body }

          it 'matches the stored response from first request' do
            expect(subject).to eq(original)
          end
        end
      end
    end
  end

  describe 'with Rack::Idempotency::Store::Redis' do
    let(:middleware) do
      Rack::Idempotency.new(app, store: Rack::Idempotency::Store::Redis.new(client: Redis.new, ttl: 5))
    end

    it_behaves_like 'functioning idempotency store'
  end

  describe 'with Rack::Idempotency::Store::Memory' do
    let(:middleware) { Rack::Idempotency.new(app, store: Rack::Idempotency::Store::Memory.new) }

    it_behaves_like 'functioning idempotency store'
  end

  describe 'with Rack::Idempotency::Store::Null' do
    let(:middleware) { Rack::Idempotency.new(app, store: Rack::Idempotency::Store::Null.new) }

    context 'without an idempotency key' do
      subject { request.post('/').body }

      it 'proceeds with original request' do
        expect(subject).not_to be_nil
      end
    end

    context 'with insecure idempotency key' do
      subject { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => 'x') }

      it 'raises a Rack::Idempotency::InsecureKeyError' do
        expect { subject }.to raise_error(Rack::Idempotency::InsecureKeyError)
      end
    end

    context 'with an idempotency key' do
      subject { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => key).body }

      context 'with a successful request' do
        context 'on first request' do
          it 'does not match any stored responses' do
            expect(subject).not_to be_nil
          end
        end

        context 'on second request' do
          let(:original) { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => key).body }

          it 'does not match any stored responses' do
            expect(subject).not_to eq(original)
          end
        end

        context 'on different request' do
          let(:different) { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => SecureRandom.uuid).body }

          it 'does not match any stored responses' do
            expect(subject).not_to eq(different)
          end
        end
      end

      context 'with a failed request' do
        let(:app) { lambda { |_| [500, { 'Content-Type' => 'text/plain' }, [SecureRandom.uuid]] } }

        context 'on first request' do
          it 'does not match any stored responses' do
            expect(subject).not_to be_nil
          end
        end

        context 'on second request' do
          let(:original) { request.post('/', 'HTTP_IDEMPOTENCY_KEY' => key).body }

          it 'does not match any stored responses' do
            expect(subject).not_to eq(original)
          end
        end
      end
    end
  end
end
