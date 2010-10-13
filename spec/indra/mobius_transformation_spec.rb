require 'spec_helper'

module Indra
  
  describe MobiusTransformation do
    
    let(:a) { 1 }
    let(:b) { 2 }
    let(:c) { 3 }
    let(:d) { 4 }
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
      
        it 'should multiply by a scalar Fixnum' do
          k = 4
          (subject * k).should == MobiusTransformation.new(k*subject.a, k*subject.b, k*subject.c, k*subject.d)
        end
        
        it 'should multiply by a scalar Float' do
          k = 4.5
          (subject * k).should == MobiusTransformation.new(k*subject.a, k*subject.b, k*subject.c, k*subject.d)
        end

        it 'should multiply by a scalar Complex' do
          k = Complex(4,1)
          (subject * k).should == MobiusTransformation.new(k*subject.a, k*subject.b, k*subject.c, k*subject.d)
        end
        
      end
      
      context 'when mutiplying a scalar by the subject' do
        
        it 'should multiply by a scalar Fixnum' do
          k = 4
          (k * subject).should == MobiusTransformation.new(k*subject.a, k*subject.b, k*subject.c, k*subject.d)
        end
        
        it 'should multiply by a scalar Float' do
          k = 4.5
          (k * subject).should == MobiusTransformation.new(k*subject.a, k*subject.b, k*subject.c, k*subject.d)
        end

        it 'should multiply by a scalar Complex' do
          k = Complex(4,1)
          (k * subject).should == MobiusTransformation.new(k*subject.a, k*subject.b, k*subject.c, k*subject.d)
        end
        
      end      
      
    end
    
    
    describe '#/' do
              
      it 'should compose the transformation with the inverse of the divisor transformation' do
        (subject / t).should == subject * t.inverse
      end
      
      context 'when dividing the subject by a scalar' do
        
        it 'should multiply by the inverse of a scalar Fixnum (and not do integer division)' do
          k = 4
          (subject / k).should == (subject * 1.0/k)
        end
        
        it 'should multiply by the inverse of a scalar Float' do
          k = 4.0
          (subject / k).should == (subject * 1/k)
        end
        
        it 'should multiply by the inverse of a scalar Complex' do
          k = Complex(4,1)
          (subject / k).should == (subject * 1/k)
        end
        
        it 'should result in infinity for all coefficients when divided by 0' do
          inf = Float::INFINITY
          infT = MobiusTransformation.new(inf,inf,inf,inf)
          (subject / 0).should == infT
          (subject / 0.0).should == infT
          (subject / Complex(0,0)).should == infT
        end
        
      end
      
      context 'when diving a scalar by the subject' do
                
        it 'should multiply a scalar Fixnum by the inverse transformation' do
          k = 4
          (k / subject).should == (k * subject.inverse)
        end
        
        it 'should multiply a scalar Float by the inverse transformation' do
          k = 4.0
          (k / subject).should == (k * subject.inverse)
        end
        
        it 'should multiply a scalar Complex by the inverse transformation' do
          k = Complex(4,1)
          (k / subject).should == (k * subject.inverse)
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
      
      it 'should multiply all coeffecieints by 1/sqrt(determinant)' do
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
    
  end
  
end