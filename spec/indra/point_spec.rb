require 'spec_helper'

module Indra

  describe Point do
  
    let(:x) { 1 }
    let(:y) { 2 }
    subject { Point[x,y] }
  
    describe '[x,y]' do
      it 'should construct a new complex number x+y*I' do
        subject.class.should be Complex
        subject.should == Complex(x,y)        
      end
    end
    
    describe '#x' do
      it 'should return x' do
        subject.x.should == x
      end
    end
    
    describe '#y' do
      it 'should return y' do
        subject.y.should == y
      end
    end
  end
  
end
