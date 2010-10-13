require 'spec_helper'

module Indra

  describe Circle do
    
    let(:center) { Complex(5,4) }
    let(:radius) { 3 }
    subject { Circle.new(center,radius) }
    
    it 'should enforce that the center is a Complex number' do
      lambda{ Circle.new(radius, radius) }.should raise_error(ArgumentError)
    end
    
    it 'should enforce that the radius is a one-dimensional (non-complex) number' do
      lambda{ Circle.new(center, center) }.should raise_error(ArgumentError)
    end
    
    it 'should be immutable' do
      lambda{ subject.center = center }.should raise_error(NoMethodError)
      lambda{ subject.radius = radius }.should raise_error(NoMethodError)
    end
    
    describe '#center' do
      it 'should return the center' do
        subject.center.should == center
      end
      it 'should be aliased by #c' do
        subject.c.should == center        
      end
    end
    
    describe '#radius' do
      it 'should return the radius' do
        subject.radius.should == radius
      end
      it 'should be aliased by #r' do
        subject.r.should == radius    
      end
    end
            
  end
  
end
