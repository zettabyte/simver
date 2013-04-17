# encoding: utf-8
require 'simver/version'

class Simver
  def initialize(source)
    raise ArgumentError, "version numbers cannot be negative" if source < 0
  end
end
