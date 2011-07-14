require File.dirname(__FILE__) +"/chromosome_base"



class GA
  attr_accessor  :mutation_rate, :population_size, :curr_population, :chromosome_klass, :generation_count

  DEFAULTS = {:mutation_rate => 0.25, :population_size => 1000, :elitism_rate => 0.10 }

  # Must be initialized with a chromosome class
  # chromosomes should extend BaseChromosome and minimally implement:
  #   - calc_fitness: determines the overall fitness score of a particular chromosome (higher is better)
  #   - random (class method): creates a new random chromosome
  #
  # Accepts an optional hash containing the following parameters:
  #   - mutation_rate: the rate of random mutation
  #   - elitism_rate: the rate of favoritism towards population elites
  #   - population_size: the overall size of of the population from generation to generation
  #
  def initialize(chromosome_klass, options={})
    @mutation_rate = options[:mutation_rate] || DEFAULTS[:mutation_rate]
    @population_size = options[:population_size] || DEFAULTS[:population_size]
    @chromosome_klass = chromosome_klass
    @generation_count = 0
    @elitism_rate = options[:elitism_rate] || DEFAULTS[:elitism_rate]
  end

  # evolves our population thru a series of generations
  def evolve!(num_generations = 1)

    @num_generations = num_generations
    seed_initial_population

    puts "Starting evolution for #{@num_generations} generations ..."
    num_generations.times do
      @generation_count += 1
      
      # calculate fitness
      @curr_population.each { |x| x.calc_fitness }

      # sort population by fitness
      @curr_population.sort! { |a, b| b.fitness <=> a.fitness }

      # print best
      puts "Generation: #{generation_count}, best: #{@curr_population[0]}"

      # add elites to new population
      new_pop = []
      num_elites = (@elitism_rate * @population_size).to_i
      elites = @curr_population.slice(0, num_elites)
      elites.each { |elite| new_pop << elite }

      # mate to create remaining population
      int_pop = mate(@curr_population, @population_size - num_elites)
      int_pop.each { |x| new_pop << x}

      @curr_population = new_pop
    end

  end

  # seed the initial population
  def seed_initial_population
    puts "Building initial population of size: #{@population_size} ..."
    @curr_population = []
    @population_size.times.each { @curr_population << @chromosome_klass.random }
  end

  # creates a new population using single pt.crossover and
  # mutation of children from parents from an input population
  def mate(in_pop, num_children)
    out_pop = []
    num_children.times do
    # selection
      mom = in_pop.slice(0, in_pop.size/2).sample
      dad = in_pop.slice(0, in_pop.size/2).sample

      # x-over
      child = crossover(mom, dad)

      # mutation
      child.mutate! if rand <= @mutation_rate

      out_pop << child
    end
    out_pop
  end

  # Performs crossover (recombination) operator on two chromosomes
  def crossover(mom, dad, split_pt = rand(mom.length))
    raise ArgumentError('mom.length must be the same as dad.length!') unless mom.length == dad.length
    genes = mom.slice(0, split_pt) + dad.slice(split_pt, dad.length)
    child = mom.class.random()
    child.set_genes(genes)
    child
  end

  def total_fitness(pop)
    pop.collect { |x| x.fitness }.reduce(:+)
  end

  # Performs "Roulette Wheel" selection whereby probability of selection is
  # proportional to the fitness of individual chromosomes (higher fitness
  # chromosomes have a higher prob. of being selected)
  def select_roulette(pop)
    tf = total_fitness(pop)
    stop = rand
    curr_val = 0
    p_sel = nil
    pop.each do |p|
      p_sel = p
      curr_val += p.fitness / tf.to_f
      break if curr_val >= stop
    end
    p_sel
  end

end

