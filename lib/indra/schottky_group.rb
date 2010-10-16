module Indra
  
  # A group of all compositions of a collection of MobiusTransformations and their inverses
  # Each transformation & inverse is assigned a corresponding letter: the original transformation is
  # lower case and the inverse is upper case (for example A is the inverse of a).
  # A sequence of letters forms a word, which represents the composition of the corresponding transformations.
  # The Schottky group consists of the words formed from all possible combinations of those letters.
  # We reduce the set of words by removing all consecutive transformations which are inverses of each other.
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
    
    # Given a word, generate all possible words with one more transformation
    # not including the inverse of the last transformation in the given word.
    def next_words_for(word)   
      if word.nil? or word.empty?
        generator_names 
      else
        name_of_last_generator_inverse = word[-1].swapcase
        generator_names.find_all{|name| name != name_of_last_generator_inverse }.map{|name| word + name }
      end
    end
    
    # All reduced generator words up to a certain length.
     def words(max_length)
       @generated_word_lengths ||= [0]
       @words_by_length ||= {0 => ['']}

       while @generated_word_lengths[-1] < max_length        
         last_length = @generated_word_lengths[-1] 
         next_length = last_length + 1
         @words_by_length[next_length] = @words_by_length[last_length].collect{|word| next_words_for word }.flatten
         @generated_word_lengths << next_length
       end

       @words_by_length.values.flatten
     end
     
     # The composed series of transformations for a given word in this group
     def transformation_for(word)
       @composed_transformations ||= {}
       transformation = @composed_transformations[word]
       if transformation.nil?
         if word.nil? or word.empty?
           transformation = MobiusTransformation::IDENTITY
         elsif word.length == 1
           transformation = @generators[word]
         else
           transformation = transformation_for(word.chop) * @generators[word[-1]]
         end
         @composed_transformations[word] = transformation
       end
       transformation
     end
    
  end
  
end