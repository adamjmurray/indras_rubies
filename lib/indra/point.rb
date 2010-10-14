module Indra
  
  # Points are just complex numbers. 
  # This class exists to help make code more readable.
  class Point
    def self.[](x,y)
      Complex(x,y)
    end
  end
  
end


# Additionally we'll add x and y methods to Complex so it acts more like a Point
class Complex
  alias x real
  alias y imag
end