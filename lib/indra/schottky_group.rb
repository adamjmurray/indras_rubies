module Indra
  
  # A group of all compositions of a collection of MobiusTransformations and their inverses
  class SchottkyGroup
    
    attr_reader :transformations, :generators, :generator_names
    
    def initialize(*transformations) 
      names = ('a'..'z').to_a # available generator names
      if transformations.length > names.length
        raise ArgumentError.new("Number of transformations exceeded maximum of 26")
      end
      
      @transformations = Array.new(transformations)
      @transformations.freeze

      @generators = {}
      @generator_names = []      
      
      @transformations.each_with_index do |t,index|
        name = names[index]
        @generator_names << name
        @generators[name] = t
        inverse_name = name.upcase
        @generator_names << inverse_name
        @generators[inverse_name] = t.inverse        
      end      
      @generators.freeze      
      @generator_names.freeze      
    end
    
  end
  
end