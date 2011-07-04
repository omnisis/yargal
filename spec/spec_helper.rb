module YargalSpecHelper

  class TestChromosome < ChromosomeBase

    #def initialize(seq) 
    #  super(seq)
    #end

    def self.random(len = 10)
      rand_genes = len.times.collect { rand(2).to_s }
      #puts "Created random chromosome: #{rand_genes.join}"
      self.new(rand_genes)
    end

    def evaluate_fitness
      fitness = self.join.to_i(2)
      #puts "Evaluating fitness of #{self.gene_seq} -- fitness is: #{fitness}"
      fitness
    end

    def self.with_fitness(fitness)
      self.new(fitness.to_s(2))
    end
  end

end
