require File.dirname(__FILE__) + "/../lib/yargal"
require File.dirname(__FILE__) + "/../lib/chromosome_base"
    
# Example Chromosome that keeps track of a mystery word and assigns
# fitness based on how close the chromosomal sequence gets to the
# mystery word
class MysteryWord < ChromosomeBase
    THEWORD = "Hello World!"

    def initialize(letters)
      if letters.kind_of? String
        letters.each_char { |c| self << c }
      else
        letters.each { |x| self << x } 
      end
    end

    def self.random()
      letters = ""
      THEWORD.length.times do
        letters += random_letter
      end
      self.new(letters)
    end

    def calc_fitness
      delta = 0
      self.each_with_index do |x, i|
          delta += (x.to_s[0].ord - THEWORD[i].ord).abs 
      end
      self.fitness = (delta == 0)?2:1/delta.to_f 
    end

    def self.random_letter
      (" ".."z").to_a.sample
    end
    
    def mutate!
      mpos = rand(THEWORD.length)
      newchar = self.class.random_letter
      self[mpos] = newchar 
      self
    end
    
    def max_fitness
      2.0
    end
    
  end
  

# MAIN
if __FILE__ == $0
    @ga = GA.new(MysteryWord, {:population_size => 1500, :mutation_rate => 0.25})
    @ga.evolve!(40)
end
