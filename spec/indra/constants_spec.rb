require 'spec_helper'

module Indra

  describe 'I' do
    it 'should be the square root of -1' do
      I.should == Math.sqrt(-1)
    end    
  end
  
  describe 'INFINITY' do
    it 'should be the value of non-zero divided by zero' do
      (1/0).should == INFINITY
    end
    it 'should result in zero when dividing any number other than INFINITY' do
      (1/INFINITY).should == 0
    end
    it 'should be aliased by INF' do
      INF.should == INFINITY
    end
  end

  describe 'NAN' do
    it 'should be the value of 0/0' do
      (0/0).should be_nan   # can't compare with equality, NAN is never equal to anything including itself!
    end
    it 'should be the value of INFINITY/INFINITY' do
      (INFINITY/INFINITY).should be_nan 
    end
  end
  
  describe 'ORIGIN' do
    it 'should be the Point [0,0]' do
      ORIGIN.should == Point[0,0]
    end
  end
  
end
