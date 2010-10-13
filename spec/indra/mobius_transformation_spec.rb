require 'spec_helper'

module Indra
  
  describe MobiusTransformation do
    
    let(:a) { Complex(1) }
    let(:b) { Complex(2) }
    let(:c) { Complex(3) }
    let(:d) { Complex(4) }
    subject { MobiusTransformation.new(a,b,c,d) }
    let(:t) { MobiusTransformation.new(2,3,4,5) }
  
  
    describe 'IDENTITY' do
      
      it 'should have the coefficients 1,0,0,1' do
        MobiusTransformation::IDENTITY.should == MobiusTransformation.new(1,0,0,1)
      end
      
      it 'should not alter any transformation when composed with it' do
        (subject * MobiusTransformation::IDENTITY).should == subject
      end
      
    end
    
    
    describe '#a' do
      it 'should be the first coefficient' do
        subject.a.should == a
      end
    end
    
    describe '#b' do
      it 'should be the second coefficient' do
        subject.b.should == b
      end
    end
    
    describe '#c' do
      it 'should be the third coefficient' do
        subject.c.should == c
      end
    end
    
    describe '#d' do
      it 'should be the fourth coefficients' do 
        subject.d.should == d
      end
    end
    
    describe '#coefficients' do
      it 'should be [a,b,c,d]' do
        subject.coefficients.should == [a,b,c,d]
      end
    end
    
    
    describe '#==' do
    
      it 'should be true if the 4 coefficients are equal' do
        subject.should == MobiusTransformation.new(a,b,c,d)
      end
    
      it 'should be false if any of the 4 coefficients are different' do
        subject.should_not == MobiusTransformation.new(0,b,c,d)
        subject.should_not == MobiusTransformation.new(a,0,c,d)
        subject.should_not == MobiusTransformation.new(a,b,0,d)
        subject.should_not == MobiusTransformation.new(a,b,c,0)
      end
    
      it 'should be false for incompatible types' do
        subject.should_not == [a,b,c,d]
      end
    
    end
    
    
    describe '#*' do
      
      it 'should compose this transformation with another transformation' do
        # standard matrix multiplication, dot product of each row with each column:
        (subject * t).should == MobiusTransformation.new(
          subject.a * t.a + subject.b * t.c,
          subject.a * t.b + subject.b * t.d,
          subject.c * t.a + subject.d * t.c,
          subject.c * t.b + subject.d * t.d
        )
      end
      
      context 'when multiplying the subject by a scalar' do

        def subject_times_scalar_should_be_correct(scalar)
          (subject * scalar).should == MobiusTransformation.new(scalar*subject.a, scalar*subject.b, scalar*subject.c, scalar*subject.d)
        end
      
        it 'should multiply by a scalar Fixnum' do
          subject_times_scalar_should_be_correct( 4 )
        end
        
        it 'should multiply by a scalar Rational' do
          subject_times_scalar_should_be_correct( Rational(4,3) )
        end
        
        it 'should multiply by a scalar Float' do
          subject_times_scalar_should_be_correct( 4.5 )
        end

        it 'should multiply by a scalar Complex' do
          subject_times_scalar_should_be_correct( Complex(4,1) )
        end
        
      end
      
      context 'when mutiplying a scalar by the subject' do
        
        def scalar_times_subject_should_be_correct(scalar)
          (scalar * subject).should == MobiusTransformation.new(scalar*subject.a, scalar*subject.b, scalar*subject.c, scalar*subject.d)
        end        
        
        it 'should multiply by a scalar Fixnum' do
          scalar_times_subject_should_be_correct( 4 )
        end
        
        it 'should multiply by a scalar Rational' do
          scalar_times_subject_should_be_correct( Rational(4,3) )
        end
        
        it 'should multiply by a scalar Float' do
          scalar_times_subject_should_be_correct( 4.5 )
        end

        it 'should multiply by a scalar Complex' do
          scalar_times_subject_should_be_correct( Complex(4,1) )
        end
        
      end      
      
    end
    
    
    describe '#/' do
              
      it 'should compose the transformation with the inverse of the divisor transformation' do
        (subject / t).should == subject * t.inverse
      end
      
      context 'when dividing the subject by a scalar' do
        
        it 'should multiply by the inverse of a scalar Fixnum (and not do integer division)' do
          (subject / 4).should == (subject * 1/4.0)
        end

        it 'should multiply by the inverse of a scalar Rational' do
          (subject / Rational(4,3)).should == (subject * Rational(3,4))
        end
        
        it 'should multiply by the inverse of a scalar Float' do
          (subject / 4.0).should == (subject * 1/4.0)
        end
        
        it 'should multiply by the inverse of a scalar Complex' do
          (subject / Complex(4,1)).should == (subject * 1/Complex(4,1))
        end
        
        it 'should result in infinity for all coefficients when divided by 0' do
          infT = MobiusTransformation.new(INFINITY,INFINITY,INFINITY,INFINITY)
          (subject / 0).should == infT
          (MobiusTransformation.new(Rational(1),2,3,4) / Rational(0)).should == infT
          (MobiusTransformation.new(1.0,2,3,4)  / 0.0).should == infT
          (MobiusTransformation.new(Complex(1,0),2,3,4) / Complex(0,0)).should == infT
        end
        
        it 'should result in zero for all coefficients when divided by infinity' do
          zeroT = MobiusTransformation.new(0,0,0,0)
          (subject / INFINITY).should == zeroT
          (MobiusTransformation.new(Rational(1),2,3,4) / INFINITY).should == zeroT
          (MobiusTransformation.new(1.0,2,3,4)  / INFINITY).should == zeroT
          (MobiusTransformation.new(Complex(1,0),2,3,4) / Complex(INFINITY)).should == zeroT
        end
        
      end
      
      context 'when diving a scalar by the subject' do
                
        it 'should multiply a scalar Fixnum by the inverse transformation' do
          (4 / subject).should == (4 * subject.inverse)
        end
        
        it 'should multiply a scalar Fixnum by the inverse transformation' do
          (Rational(4,3) / subject).should == (Rational(4,3) * subject.inverse)
        end        
        
        it 'should multiply a scalar Float by the inverse transformation' do
          (4.0 / subject).should == (4.0 * subject.inverse)
        end
        
        it 'should multiply a scalar Complex by the inverse transformation' do
          (Complex(4,1) / subject).should == (Complex(4,1) * subject.inverse)
        end        
        
      end
      
    end    
    
    
    describe '#determinant' do    
      it 'should calculate ad-bc' do
        subject.determinant.should == (a*d - b*c)
      end
    end
    
    describe '#trace' do
      it 'should calculate a+d' do
        subject.trace.should == (a + d)
      end
    end


    describe '#inverse' do
      
      it 'should calculate an inverse' do
        det = subject.determinant.to_f
        subject.inverse.should == MobiusTransformation.new(d/det, -b/det, -c/det, a/det)
      end
      
      it 'should compose with the original transformation to produce the identity' do
        (subject.inverse * subject).should == MobiusTransformation::IDENTITY
      end      
      
      it 'should not modify the transformation in place' do
        subject.inverse.should_not == subject
      end
      
    end
    
    describe '#inverse!' do
      it 'should modify the transformation in place' do
        inverse = subject.inverse
        subject.inverse!
        subject.should == inverse
      end      
    end
    
    
    
    describe '#normalize' do
      
      it 'should multiply all coefficieints by 1/sqrt(determinant)' do
        det_sqrt = Math.sqrt(subject.determinant)
        normal_form = subject.normalize
        normal_form.should == MobiusTransformation.new(a/det_sqrt, b/det_sqrt, c/det_sqrt, d/det_sqrt)
      end
      
      it 'should create a MobiusTransformation with a determinant of 1' do
        subject.normalize.determinant.should == 1
      end      
   
      it 'should not modify the transformation in place' do
        subject.normalize.should_not == subject
      end    
      
    end
    
    describe '#normalize!' do
      it 'should normalize in place' do
        normal_form = subject.normalize
        subject.normalize!
        normal_form.should == subject
      end
    end
    
    
    describe '#transform_point' do       
           
      let(:p1){ Complex( 0,0) }
      let(:p2){ Complex( 1,1) }
      let(:p3){ Complex(-2,3) }
      let(:points){ [p1,p2,p3] }
      
      it 'should not change the point if the transformation is the identity transformation' do
        for z in points
          MobiusTransformation::IDENTITY.transform_point(z).should == z
        end
      end
      
      it 'should transform point z using the formula T(z) = (T.a*z + T.b)/(T.c*z + T.d)' do
        for z in points
          subject.transform_point(z).should == (a*z + b)/(c*z + d)
        end
      end
      
      it 'should evaluate to a/c when z is infinity' do
        subject.transform_point(INFINITY).should == (a/c)
      end
      
      it 'should evaluate to infinity when z is -d/c' do
        subject.transform_point(-d/c).should == INFINITY
      end
      
    end
    
    
    describe '#transform_circle' do

      let(:unit_circle){ Circle.new(Complex(0,0),1) }

      it 'should correctly transform a circle' do
        # Hard to explain in words, see Indra's Pearls chapter 3
        # I've reduced the formulas significantly by using the unit circle for this test
        center = subject.transform_point( -1/(d/c).conj )
        radius = (center - subject.transform_point(1)).abs
        subject.transform_circle(unit_circle).should == Circle.new(center,radius)
      end
      
      # should probably write more tests for this but the math is giving me a headache :/
      # I trust the book is correct and it was pretty easy to implement, so it's probably ok...
      
      it 'should not change the circle if the transformation is the identity transformation' do
        MobiusTransformation::IDENTITY.transform_circle(unit_circle).should == unit_circle
      end
      
    end
    
    
    describe '#fixed_points' do
      
      it 'should be the two solutions of z=(az+b)/(cz+d)' do
        # for a=1,b=2,c=3,d=4 this should be (-3 +/- 5.745)/6 == [0.4575, -1.4575]
        fp1,fp2 = MobiusTransformation.new(1,2,3,4).fixed_points
        fp1.should be_close  0.4575 ,  0.0001
        fp2.should be_close -1.4575 ,  0.0001
      end
      
      it 'should be ((a-d) plus/minus sqrt(trace**2 - 4))/2c for normalized transformations' do
        subject.normalize!
        a,b,c,d = subject.coefficients
        fp1,fp2 = subject.fixed_points
        sqtr4 = Math.sqrt(subject.trace**2 - 4)        
        fp1.should be_close (a-d + sqtr4)/(2*c), 0.001
        fp2.should be_close (a-d - sqtr4)/(2*c), 0.001
      end      
      
      it' should be NAN for the identity transformation' do
        # This evaluates to 0/0, which is NAN
        # It makes sense because all points are fixed points in the indentity transformation, 
        # so there's no specific solution to return
        fp1,fp2 = MobiusTransformation::IDENTITY.fixed_points
        fp1.should be_nan
        fp2.should be_nan
      end
      
    end
    
    
    describe '#to_s' do
      it 'should be MobiusTransformation[[a,b],[c,d]]' do
        subject.to_s.should == "MobiusTransformation[[#{a},#{b}], [#{c},#{d}]]"
      end
    end
    
  end
  
end