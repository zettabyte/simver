# encoding: utf-8
require 'spec_helper'
describe Simver::Part do
  describe '.new' do

    it "sets #parts to a list of the dot-separated components provided in the +part+ string" do
      Simver::Part.new("1.2.3").parts.should == %w{ 1 2 3 }
    end

    it "fails if +part+ isn't a value that can be converted to a String via #to_s" do
      evil = Object.new
      def evil.to_s
        raise "Ha ha ha! No string for you!!!"
      end
      expect { Simver::Part.new(evil) }.to raise_error(RuntimeError, /ha ha ha/i)
    end

    it "fails if +part+, once converted to a string, is empty" do
      expect { Simver::Part.new("") }.to raise_error(ArgumentError)
    end

    it "fails if +part+ starts with a dot, defining an empty first part" do
      expect { Simver::Part.new(".1.2") }.to raise_error(ArgumentError)
    end

    it "fails if +part+ ends with a dot, defining an empty last part" do
      expect { Simver::Part.new("1.2.") }.to raise_error(ArgumentError)
    end

    it "fails if +part+ has two consecutive dots, defining an empty part" do
      expect { Simver::Part.new("1..2") }.to raise_error(ArgumentError)
    end

    it "fails if any of the dot-separated components have any non-hyphen, non-alphanumeric characters" do
      expect { Simver::Part.new("1.%2.3") }.to raise_error(ArgumentError)
      expect { Simver::Part.new(" 1.2.3") }.to raise_error(ArgumentError)
    end

  end # describe '.new'

  describe '#parts' do
    it "returns a frozen array" do
      Simver::Part.new("1.2.3").parts.should be_frozen
    end

    it "returns an array of frozen strings" do
      Simver::Part.new("1.2.3").parts.all? { |part| part.should be_frozen }
    end
  end # describe '#parts'
end   # describe Simver::Part
