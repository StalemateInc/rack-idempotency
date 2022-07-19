# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::Idempotency::Store::Redis do
  let(:redis) { instance_spy(::Redis) }
  let(:value) { 'd353c6836cc8c2a0bcf79626bb64bc48032e33ece8e8407c4cb65830965fa814' }

  describe '#write' do
    subject! { store.write('key', value) }

    context 'with positive TTL' do
      let(:store) { described_class.new(client: redis, ttl: 5) }

      it 'sets the key expiring in TTL seconds' do
        expect(redis).to have_received(:setex).with('key', 5, value).once
      end
    end

    context 'with negative or zero TTL' do
      let(:store) { described_class.new(client: redis, ttl: -5) }

      it 'sets the key without expiration' do
        expect(redis).to have_received(:set).with('key', value).once
      end
    end

    context 'without a provided TTL' do
      let(:store) { described_class.new(client: redis) }

      it 'sets the key for default TTL' do
        expect(redis).to have_received(:setex).with('key', described_class::DEFAULT_TTL, value).once
      end
    end
  end

  describe '#read' do
    subject! { store.read('key') }

    let(:store) { described_class.new(client: redis) }

    before { redis.set('key', value) }

    it 'reads value using Redis client' do
      expect(redis).to have_received(:get).with('key')
    end
  end
end
