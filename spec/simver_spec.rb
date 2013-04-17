# encoding: utf-8
require 'spec_helper'

describe Simver do
  describe '.new' do # or rather '#initialize'

    it "fails if passed a negative integer" do
      expect { Simver.new(-1) }.to raise_error(ArgumentError, /version numbers cannot be negative/i)
    end

  end # describe '.new'
end   # describe Simver
