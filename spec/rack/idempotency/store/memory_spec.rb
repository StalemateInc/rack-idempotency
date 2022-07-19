# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::Idempotency::Store::Memory do
  let(:store) { described_class.new }
  let(:value) { 'd353c6836cc8c2a0bcf79626bb64bc48032e33ece8e8407c4cb65830965fa814' }

  describe '#write' do
    subject { store.write('key', value) }

    it 'stores value in memory' do
      expect(subject).to eq(value)
      expect(store.read('key')).to eq(value)
    end
  end

  describe '#read' do
    subject { store.read('key') }

    it 'reads value from memory' do
      store.write('key', value)
      expect(subject).to eq(value)
    end
  end
end
