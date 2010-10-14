module Indra
  
  Point = Complex

  # Points are just complex numbers. 
  # This helps make code more readable.  
  class Point
    alias x real
    alias y imag
  end
  
end

module Kernel
  def Point(x,y)
    Complex(x,y)
  end
end
