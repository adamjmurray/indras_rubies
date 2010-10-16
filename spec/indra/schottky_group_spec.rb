require 'spec_helper'

module Indra

  describe SchottkyGroup do
  
    let(:t1) { MobiusTransformation.new(1,2,3,4) }
    let(:t2) { MobiusTransformation.new(I,-I,0,I) }
    let(:transformations) { [t1,t2] }
    let(:inverse_transformations) { [t1.inverse,t2.inverse] }
    subject { SchottkyGroup.new(*transformations) }
  
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

  end
  
end
