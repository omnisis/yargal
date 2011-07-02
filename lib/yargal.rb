require 'chromosome_base'
require 'population'
require 'array_helper'

class GA
  #include ArrayHelper
  attr_accessor :crossover_rate, :mutation_rate, :population_size, :curr_population, :chromosome_length

  # Must be initialized with a chromosome class
  # chromosomes should extend BaseChromosome and implement:
  #   - evaluate_fitness: determines the overall fitness score of a particular chromosome (higher is better)
  # 
  # Accepts an optional hash containing the following parameters:
  #   - crossover_rate: the rate that crossover will occur
  #   - mutation_rate: the rate of random mutation 
  #   - chromosome_len: the bitlength of a single binary encoded chromosome
  #   - population_size: the overall size of of the population from generation to generation
  def initialize(chromosome, options={}) 
    @crossover_rate = options[:crossover_rate] || 0.7
    @mutation_rate = options[:mutation_rate] || 0.001
    @population_size = options[:population_size] || 50
    @logger = options[:logger] if options[:logger]
    @chromosome_length = options[:chromosome_length] || 10
  end

  # evolves our population thru a series of generations
  def evolve(num_times = 1, options = {})
    @curr_population || build_initial_population
    p @curr_population

    # evaluate fitness
    fitness_scores = @curr_population.calc_fitness

    # select parents
    new_pop = Population.new(@population_size)
    @curr_population.in_groups_of(2) do
      mum, dad = select(@curr_population, 2)  # select 2 members from the current population
      children =  crossover(mum, dad)
      mutate(children)
      new_pop << children # add children to new population
    end

    # replace current population
    @curr_population = new_pop
  end


  # Performs crossover (recombination) operator on two chromosomes
  def crossover(mum, dad)
    #TODO: implement this
    [mum, dad]
  end

  # Performs mutation operator on two chromosomes
  def mutate(children)
    #TODO: implement this
    children
  end

  # Performs selection from the given population and returns
  # a new population consisting of num_members chromosomes 
  def select(pop, num_members = 1)
    selections = Population.new() 
    members.collect { select_roulette(pop) }.each { |x| selections << x }
  end

  # Performs "Roulette Wheel" selection whereby probability of selection is
  # proportional to the fitness of individual chromosomes (higher fitness
  # chromosomes have a higher prob. of being selected)
  def select_roulette(pop)
    r = rand(pop.total_fitness) + 1
    curr_fit_total = 0
    i = 0
    begin
      selected_chromosome = pop[i]
      curr_fit_total += selected_chromosome.fitness
      i += 1
    end while curr_fit_total < r
    selected_chromosome
  end


  private


  # builds an initial generation of chromosomes from the chromosome class given at construction
  def build_initial_population
    @population_size.times do
      @curr_population << chromosome.new(@chromosome_length)
    end
  end

end
