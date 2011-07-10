module YargalSpecHelper

  class TestChromosome < ChromosomeBase

    #def initialize(seq) 
    #  super(seq)
    #end

    def self.random(len = 10)
      rand_genes = len.times.collect { rand(2).to_s }
      self.new(rand_genes)
    end

    def evaluate_fitness
      fitness = self.join.to_i(2)
      fitness
    end

    def mutate!
    end

    def self.with_fitness(fitness)
      self.new(fitness.to_s(2))
    end
  end



  class MysteryWord < ChromosomeBase 
    #< ChromosomeBase
    THEWORD = "camelot"

    def initialize(letters)
      if letters.kind_of? String
        letters.each_char { |c| self << c }
      else
        letters.each { |x| self << x } 
      end
    end

    def self.random()
      letters = ""
      THEWORD.each_char do 
        letters += random_letter
      end
      self.new(letters)
    end

    def is_exact_match?
      self.each_index do |i|
        return false if self[i] != THEWORD[i]
      end
    end

    def evaluate_fitness
      likeness = 0.0
      self.each_index do |i| 
          diff = (self[i].ord - THEWORD[i].ord).abs
          if diff == 0
            likeness += 1.0
          else
            likeness += (25 - diff) / 26.0
          end
      end
      self.fitness = likeness.to_f / THEWORD.length
    end

    def self.random_letter
      ("a".."z").to_a.sample
    end

    def mutate!
      m_idx1, m_idx2 = rand(self.size), rand(self.size)
      self[m_idx1] = MysteryWord.random_letter
      self[m_idx2] = MysteryWord.random_letter
    end

  end

end
