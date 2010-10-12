require 'spec_helper'

module Indra
  
  describe MobiusTransformation do
    
    let(:a) { 1 }
    let(:b) { 2 }
    let(:c) { 3 }
    let(:d) { 4 }
    subject { MobiusTransformation.new(a,b,c,d) }
  
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
      it 'should compose two transformations' do
        t = MobiusTransformation.new(2,3,4,5)        
        st = subject * t
        # standard matrix multiplication, dot product of each row with each column:
        st.should == MobiusTransformation.new(
          subject.a * t.a + subject.b * t.c,
          subject.a * t.b + subject.b * t.d,
          subject.c * t.a + subject.d * t.c,
          subject.c * t.b + subject.d * t.d
        )
      end
    end
    
    describe '#determinant' do    
      it 'should calculate ad-bc' do
        subject.determinant.should == (a*d - b*c)
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