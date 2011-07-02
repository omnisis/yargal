module YargalSpecHelper
  class TestChromosome < ChromosomeBase
    def initialize(fitness)
      @fitness = fitness
    end

    def evaluate_fitness
      @fitness
    end
  end
end
