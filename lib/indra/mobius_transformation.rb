module Indra

  #  Mobius transformations are basically 2x2 matrixes of the form [[a,b],[c,d]]
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
    
    def coefficients
      [a,b,c,d]
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
    
    def trace
      @matrix.trace
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
    
    def /(other)
      if other.respond_to? :matrix
        MobiusTransformation.new(@matrix * other.matrix.inverse, nil,nil,nil)
      else
        if other.is_a? Fixnum
          # I can't imagine a case where I'd want to actually perform integer division
          # on a transformation matrix, so we'll force it to use floating point:
          other = other.to_f
        end
        MobiusTransformation.new(a/other, b/other, c/other, d/other)
      end
    end
    
    def transform_point(z)
      if z == INFINITY   
        # see Indra's Pearl's page 75
        # By applying an algebraic reduction for this case we can avoid the undefined value INFINITY/INFINITY
        a/c  
      else
        (a*z + b)/(c*z + d)
      end
    end
    
    def transform_circle(circle)
      # see Indra's Pearl's box 10, page 91
      p = circle.center
      r = circle.radius
      z = p - (r**2)/(d/c + p).conj
      q = transform_point(z)
      s = ( q - transform_point(p+r) ).abs
      Circle.new(q,s)
    end
    
    def [](shape)
      case shape
      when Point
        transform_point(shape)
      when Circle
        transform_circle(shape)
      else
        raise ArgumentError
      end
    end
    
    def fixed_points
      # See Ingra's Pearls Note 3.3 on page 78      
      numerator_left = a-d # the numerator on the left side of plus/minus
      numerator_right = Math.sqrt((d-a)**2 + 4*b*c)
      denominator = 2*c      
      [(numerator_left + numerator_right)/denominator,
       (numerator_left - numerator_right)/denominator]
    end
    
    def to_s
      "MobiusTransformation[[#{a},#{b}], [#{c},#{d}]]"
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



#################################################################################
# Monkey Patches to Numeric classes so they place nice with MobiusTransformations

for klass in [Fixnum,Rational,Float,Complex] do
  klass.class_eval do # metaprogramming FTW!
    
    alias non_mobius_transformation_multiply *
    def *(other)
      if other.is_a? Indra::MobiusTransformation
        other * self
      else 
        non_mobius_transformation_multiply(other)
      end
    end

    alias non_mobius_transformation_divide /
    def /(other)
      if other.is_a? Indra::MobiusTransformation
        other.inverse * self
      elsif other == 0
        # And while we're in here let's fix divide by 0 to work like it should         
        if self == 0
          Float::NAN
        else
          Float::INFINITY
        end
      else
        non_mobius_transformation_divide(other)
      end
    end
    
  end
end
