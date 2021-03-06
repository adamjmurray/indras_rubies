require 'spec_helper'

module Indra

  describe Circle do
    
    let(:center) { Complex(5,4) }
    let(:radius) { 3 }
    subject { Circle.new(center,radius) }
    
    it 'should be immutable' do
      lambda{ subject.center = center }.should raise_error(NoMethodError)
      lambda{ subject.radius = radius }.should raise_error(NoMethodError)
    end

    describe 'new' do
      it 'should convert the center to a Complex number when possible' do
        Circle.new([5,4], 3).should == Circle.new(Complex(5,4), 3)
        Circle.new(5, 3).should == Circle.new(Complex(5,0), 3)
      end
    
      it 'should enforce that the center is a Complex number' do
        lambda{ Circle.new("not a center", radius) }.should raise_error(ArgumentError)
      end
    
      it 'should enforce that the radius is a one-dimensional (non-complex) number' do
        lambda{ Circle.new(center, center) }.should raise_error(ArgumentError)
      end
    end
    
    describe '#center' do
      it 'should return the center' do
        subject.center.should == center
      end
      it 'should be aliased by #c' do
        subject.c.should == center        
      end
    end
    
    describe '#x' do 
      it "should return center's real component" do
        subject.x.should == subject.center.real
      end
    end
    
    describe '#y' do
      it "should return center's imaginary component" do
        subject.y.should == subject.center.imag
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
    
    describe '#==' do
      it 'should be true when comparing the same object' do
        subject.should == subject
      end
      it 'should be true when comparing objects with the same center and radius' do
        subject.should == Circle.new(subject.center, subject.radius)
      end
      it 'should be false when comparing objects with different centers and radii' do
        subject.should_not == Circle.new(subject.center+1, subject.radius)
        subject.should_not == Circle.new(subject.center+1, subject.radius+1)
      end
      it' should be false when comapring and object with no center or radius' do
        subject.should_not == subject.center
      end
    end
    
    describe '#to_s' do
      it 'should be "Circle[@center=#{center} @radius=#{radius}]"' do
        subject.to_s.should == "Circle[@center=#{center} @radius=#{radius}]"
      end
    end
                  
  end
  
end
