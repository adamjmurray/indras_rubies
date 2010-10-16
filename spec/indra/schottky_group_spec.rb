require 'spec_helper'

module Indra

  describe SchottkyGroup do
  
    let(:a) { MobiusTransformation.new(1,2,3,4) }
    let(:b) { MobiusTransformation.new(I,-I,0,I) }
    let(:transformations) { [a,b] }
    let(:inverse_transformations) { [a.inverse,b.inverse] }
    subject { SchottkyGroup.new(*transformations) }
  
    before(:all) do
      A = a.inverse
      B = b.inverse
    end
  
    describe 'new' do
      it 'should allow up to 26 transformations' do
        SchottkyGroup.new(*Array.new(26,a))
      end
    end
  
  
    describe '#transformations' do
      it 'should be the list transformations used to initialize the object' do
        subject.transformations.should == transformations
      end
      
      it 'should be immutable' do
        lambda{ subject.transformations = :anything }.should raise_error
        lambda{ subject.transformations << :anything }.should raise_error
        lambda{ subject.transformations[0] = :anything }.should raise_error
        lambda{ subject.transformations.delete_at(0) }.should raise_error
      end
    end
  
    
    describe '#generator_names' do
      it 'should be an Array with a lower case & upper case letter for each transformation & inverse' do
        lowercase_names = ('a'..'z').to_a.slice(0,transformations.length)
        uppercase_names = ('A'..'Z').to_a.slice(0,inverse_transformations.length)
        subject.generator_names.should =~ lowercase_names + uppercase_names
      end
      
      it 'should be immutable' do
        lambda{ subject.generator_names = :anything }.should raise_error
        lambda{ subject.generator_names << :anything }.should raise_error
        lambda{ subject.generator_names[0] = :anything }.should raise_error
        lambda{ subject.transformations.delete_at(0) }.should raise_error
      end
    end
    
    
    describe '#generators' do
      it 'should be a Hash with the generator_names as keys' do
        subject.generators.keys.should =~ subject.generator_names
      end   
         
      it 'should be a Hash with the transformations & inverse transformations as values' do
        subject.generators.values =~ transformations + inverse_transformations
      end
      
      it 'should map lower case generator names to the original transformations' do
        subject.generators.keys.find_all{|k| k == k.downcase }.map{|k| subject.generators[k] }.should =~ transformations
      end
      
      it 'should map upper case generator names to the inverse transformations' do
        subject.generators.keys.find_all{|k| k == k.upcase }.map{|k| subject.generators[k] }.should =~ inverse_transformations
      end
      
      it 'should be immutable' do
        lambda{ subject.generators = :anything }.should raise_error
        lambda{ subject.generators[generator_names[0]] << :anything }.should raise_error
        lambda{ subject.generators[:new_key] << :anything }.should raise_error
        lambda{ subject.generators.delete generator_names[0] }.should raise_error
      end
    end
    
    
    describe '#next_words_for(word)' do
      it 'should generate all possible reduced words with one more transformation' do
        subject.next_words_for('aB').should =~ ['aBa', 'aBA', 'aBB']
      end
      
      it 'should return the generator names when given the empty word as an empty string' do
        subject.next_words_for('').should =~ subject.generator_names
      end
      
      it 'should return the generator names when given the empty word as nil' do
        subject.next_words_for(nil).should =~ subject.generator_names
      end      
    end
    

    describe '#words(max_length)' do
      it 'should return only the empty word when max_length is 0' do
        subject.words(0).should == ['']        
      end
      
      it 'should return the empty word plus generator names when max_length is 1' do
        subject.words(1).should =~ [''] + subject.generator_names
      end
      
      it 'should return all reduced words up to max_length' do
        subject.words(2).should =~ ['', 'a', 'A', 'b', 'B', 
                                    'aa', 'ab', 'aB',
                                    'AA', 'Ab', 'AB',
                                    'ba', 'bA', 'bb',
                                    'Ba', 'BA', 'BB']       
        subject.words(4).length.should == 1 + 4*3**0 + 4*3**1 + 4*3**2 + 4*3**3
      end
      
      it 'should never return a non-reduced word (a word where any consecutive transformations are inverses)' do
        for word in subject.words(3)
          word.should_not =~ /aA/
          word.should_not =~ /Aa/
          word.should_not =~ /bB/
          word.should_not =~ /Bb/          
        end
      end
    end
    
    
    describe '#transformation_for(word)' do
      it 'should return the identity when given the empty word as an empty string' do
        subject.transformation_for('').should == MobiusTransformation::IDENTITY        
      end
      
      it 'should return the identity when given the empty word as nil' do
        subject.transformation_for(nil).should == MobiusTransformation::IDENTITY        
      end
      
      it 'should return the original transfomations for single letter lowercase words' do
        subject.transformation_for('a').should == a
        subject.transformation_for('b').should == b
      end
      
      it 'should return the inverse transfomations for single letter uppercase words' do
        subject.transformation_for('A').should == A
        subject.transformation_for('B').should == B
      end
      
      it 'should return composed transformations for words of 2 letters' do
        subject.transformation_for('aa').should == a * a
        subject.transformation_for('ab').should == a * b
        subject.transformation_for('aB').should == a * B
        subject.transformation_for('AA').should == A * A
        subject.transformation_for('Ab').should == A * b
        subject.transformation_for('AB').should == A * B
        subject.transformation_for('ba').should == b * a
        subject.transformation_for('bA').should == b * A
        subject.transformation_for('bb').should == b * b
        subject.transformation_for('Ba').should == B * a
        subject.transformation_for('BA').should == B * A
        subject.transformation_for('BB').should == B * B
      end
      
      it 'should return composed transformations for words of more than 2 letters' do
        subject.transformation_for('aBBAbaa').should == a * B * B * A * b * a * a
      end
    end

  end
  
end
