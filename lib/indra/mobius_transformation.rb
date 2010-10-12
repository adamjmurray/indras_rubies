module Indra

  # We will be using matrixes of the form [[a,b],[c,d]] to represent Mobius transformations
  # so let's provide a convenient constructor and accessors a,b,c,d.
  # Additionally we will coerce everything to floats so that division by 0 evaluates to Infinity, 
  # as we expect on the Riemann sphere (http://en.wikipedia.org/wiki/Riemann_sphere)
  class MobiusTransformation
    
    def initialize(a,b,c,d)
      if a.kind_of? Matrix
        @matrix = a
      else
        init_matrix(a,b,c,d)
      end
    end        
    
    def matrix
      @matrix
    end

    def a
      @matrix[0,0]
    end

    def b
      @matrix[0,1]
    end

    def c
      @matrix[1,0]
    end

    def d
      @matrix[1,1]
    end
    
    def ==(other)
      if other.respond_to? :matrix
        other.matrix == @matrix
      else
        false
      end
    end
        
    def determinant
      @matrix.determinant
    end
    
    def normalize      
      MobiusTransformation.new(*normalized_coeffecients)
    end
    
    def normalize!
      init_matrix(*normalized_coeffecients)
    end
    
    def inverse
      MobiusTransformation.new(@matrix.inverse, nil,nil,nil)
    end
    
    def inverse!
      @matrix = @matrix.inverse
    end

    def *(other)
      if other.respond_to? :matrix
        # order matters! other.matrix * @matrix is not correct
        MobiusTransformation.new(@matrix * other.matrix, nil,nil,nil)
      else
        MobiusTransformation.new(a*other, b*other, c*other, d*other)
      end
    end
    
    ############################
    private
    
    def init_matrix(a,b,c,d)
      @matrix = Matrix[ [a,b], [c,d] ]
    end 
    
    def normalized_coeffecients
      det_sqrt = Math.sqrt(@matrix.determinant) # assumes we're working with complex numbers
      return a/det_sqrt, b/det_sqrt, c/det_sqrt, d/det_sqrt
    end
    
    ############################
    public        
    
    IDENTITY = MobiusTransformation.new(1,0,0,1)    
    
  end
  
end