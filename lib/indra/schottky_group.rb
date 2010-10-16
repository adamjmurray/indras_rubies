module Indra
  
  # A group of all compositions of a collection of MobiusTransformations and their inverses
  class SchottkyGroup
    
    attr_reader :transformations, :generators, :generator_names
    
    def initialize(*transformations) 
      if transformations.length > 26
        raise ArgumentError.new("Number of transformations exceeded maximum of 26")
        # Otherwise we'll have problems with the simplistic generator A-Z naming scheme.
        # This could certainly be enhanced but I don't expect to use anywhere close to
        # 26 transformations, so I am imposing this limit for now.
      end
      @transformations = Array.new(transformations)
      @transformations.freeze

      @generators = {}
      @generator_names = []      
      names = ('a'..'z').to_a
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