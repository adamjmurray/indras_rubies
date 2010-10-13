module Indra
  
  # A simple representation of a circle.
  # Assumes we'll be using Complex numbers to represent points.
  class Circle
    
    attr_reader :center, :radius    
    alias c center
    alias r radius    
    
    def initialize(center, radius)
      if not center.is_a? Complex
        raise ArgumentError.new("center must be a Complex number")
      end
      if not radius.is_a? Numeric or radius.is_a? Complex
        raise ArgumentError.new("radius must be a one-dimensional (non-Complex) Numeric")
      end
      @center, @radius = center, radius
    end
    
  end
  
end