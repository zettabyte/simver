# encoding: utf-8
class Simver
  class Part

    VALID = /\A[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*\z/

    attr_reader :parts
    attr_reader :original

    def initialize(part)
      @original = part.to_s.freeze
      unless original =~ VALID
        raise ArgumentError, "invalid format/value for +part+ parameter: #{part.inspect}"
      end
      @parts = original.split('.').map { |p| p.freeze }.freeze
    end

  end
end
