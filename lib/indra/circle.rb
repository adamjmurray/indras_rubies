module Indra
  
  # A simple representation of a circle.
  # Assumes we'll be using Complex numbers to represent points.
  class Circle
    
    attr_reader :center, :radius    
    alias c center
    alias r radius    
    
    def initialize(center, radius)      
      if not center.is_a? Complex
        center = Complex(*center)
      end
      if not radius.is_a? Numeric or radius.is_a? Complex
        raise ArgumentError.new("radius must be a one-dimensional (non-Complex) Numeric. Was: " + radius.class.to_s)
      end
      @center, @radius = center, radius
    end
    
    def x
      center.real
    end
    
    def y
      center.imag
    end
    
    def ==(other)
      if other.respond_to? :center and other.respond_to? :radius
        center == other.center and radius == other.radius
      else
        false
      end
    end
    
    def to_s
      "Circle[@center=#{center} @radius=#{radius}]"
    end
  end
  
end