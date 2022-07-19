# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::Idempotency::Store::Null do
  let(:store) { described_class.new }
  let(:value) { 'd353c6836cc8c2a0bcf79626bb64bc48032e33ece8e8407c4cb65830965fa814' }

  describe '#write' do
    subject { store.write('key', value) }

    it 'stores nothing' do
      expect(subject).to be_nil
      expect(store.read('key')).to be_nil
    end
  end

  describe '#read' do
    subject { store.read('key') }

    it 'reads nothing' do
      store.write('key', value)
      expect(subject).to be_nil
    end
  end
end
