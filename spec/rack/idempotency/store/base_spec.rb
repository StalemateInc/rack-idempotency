# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::Idempotency::Store::Base do
  describe '#write' do
    subject { described_class.new.write('key', 'd353c6836cc8c2a0bcf79626bb64bc48032e33ece8e8407c4cb65830965fa814') }

    it 'raises NotImplementedError' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  describe '#read' do
    subject { described_class.new.read('key') }

    it 'raises NotImplementedError' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end
end
