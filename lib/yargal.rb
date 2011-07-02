class GA
  attr_accessor :crossover_rate, :mutation_rate, :chromosome_len, :population_size, :current_population

  # Must be initialized with a chromosome class
  # chromosomes should extend BaseChromosome and implement:
  #   - fitness: determines the overall fitness score of a particular chromosome (higher is better)
  # 
  # Accepts an optional hash containing the following parameters:
  #   - crossover_rate: the rate that crossover will occur
  #   - mutation_rate: the rate of random mutation 
  #   - chromosome_len: the bitlength of a single binary encoded chromosome
  #   - population_size: the overall size of of the population from generation to generation
  def initialize(chromosome, options={}) 
    @crossover_rate = options[:crossover_rate] || 0.7
    @mutation_rate = options[:mutation_rate] || 0.001
    @chromosome_len = options[:chromosome_len] 
    @population_size = options[:population_size] || 50
  end

  # evolves our population thru the gien number of generations 
  # (default is 1)
  def evolve(num_generations = 1)
  end


  # Performs selection from the given population and returns
  # the selected population
  def select(g)
    new_pop = []
    total_fitness = g.collect { |x| x.fitness }.inject { |sum, n| sum + n }
    @population_size.times do
      new_pop << select_roulette_with_total(g, total_fitness)
    end
    new_pop
  end

  # Roulette Wheel algorithm for selection
  def select_roulette(g)
    total_fitness = g.collect { |x| x.fitness }.inject { |sum, n| sum + n }
    select_roulette_with_total(g, total_fitness)
  end

  private

  def select_roulette_with_total(g, total_fitness)
    r = rand(total_fitness) + 1
    curr_fit_total = 0
    i = 0
    begin
      selected_chromosome = g[i]
      curr_fit_total += selected_chromosome.fitness
      i += 1
    end while curr_fit_total < r
    selected_chromosome
  end

end

class BaseChromosome < Array
  def decode
    raise NotImplementedError.new("You must implement decode!")
  end
end
