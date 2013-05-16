# encoding: utf-8
class Simver
  class Part

    VALID = /\A[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*\z/

    def initialize(part)
      unless part.to_s =~ VALID
        raise ArgumentError, "invalid format/value for +part+ parameter: #{part.inspect}"
      end
      @parts = part.to_s.split('.').map { |p| p.freeze }.freeze
    end

    attr_reader :parts

  end
end
