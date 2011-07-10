require 'chromosome_base'
require 'population'
require 'array_helper'

class GA
  attr_accessor :crossover_rate, :mutation_rate, :population_size, :curr_population, :chromosome_length, :chromosome_klass, :generation_count

  # Must be initialized with a chromosome class
  # chromosomes should extend BaseChromosome and minimally implement:
  #   - evaluate_fitness: determines the overall fitness score of a particular chromosome (higher is better)
  #   - random: creates a new random chromosome
  # 
  # Accepts an optional hash containing the following parameters:
  #   - crossover_rate: the rate that crossover will occur
  #   - mutation_rate: the rate of random mutation 
  #   - chromosome_len: the bitlength of a single binary encoded chromosome
  #   - population_size: the overall size of of the population from generation to generation
  def initialize(chromosome_klass, options={}) 
    @crossover_rate = options[:crossover_rate] || 0.8
    @mutation_rate = options[:mutation_rate] || 0.001
    @population_size = options[:population_size] || 50
    @logger = options[:logger] if options[:logger]
    @chromosome_klass = chromosome_klass
    @generation_count = 0
    @elitism_factor = options[:elitism_factor] || 0.05 
    @initial_population_size = options[:initial_population_size] || 5000
    build_initial_population
  end

  # evolves our population thru a series of generations
  def evolve!(num_generations = 1)
	@num_generations = num_generations
    seed_initial_population

    num_generations.times do
      perform_evolution!
    end
  end

  # seed the initial population
  def seed_initial_population
    @seed_population = Population.new
    @initial_population_size.times do
      @seed_population << @chromosome_klass.random
    end
    @seed_population.calc_fitness
    #@curr_population = Population.from_a(@seed_population.most_fit(@population_size))
    @curr_population = Population.from_a(@seed_population.sample(@population_size))
  end

  def perform_evolution!()
    #print_currgen

    # create intermediate pop from stochastically sample members of the current pop
    new_pop = Population.new()
    @curr_population.sample(@population_size).each { |x| new_pop << x }
    #puts "intermediate population: #{new_pop}"

    # clear out the current population
    @curr_population.clear  

    new_pop.in_groups_of(2) do |mom,dad|
      # handle case of odd population size
      dad = new_pop.sample if dad.nil? 

      # x-over
      children = crossover(mom, dad)

      # mutation
      children.each do |child| 
        break if @curr_population.size == @population_size
        child.mutate! if rand <= @mutation_rate
        @curr_population << child 
      end 

    end

    # primitive elitism
    #fittest = @curr_population.most_fit(5)
    #@curr_population.pop(5)
    #fittest.each { |x| @curr_population << x }
    
    # update generation count
    @curr_population.generation += 1

    # update fitness
    @curr_population.calc_fitness
    print_stats

  end

  def print_stats
    #puts "------------------------------------------------------------------------"
    #puts "generation [#{@curr_population.generation}] -- " +
     #     "mean fitness [#{format("%8.8g", @curr_population.mean_fitness)}] -- " +
      #    "total fitness [#{format("%8.8g", @curr_population.total_fitness)}]"
    #puts "------------------------------------------------------------------------"
	printf "%s", "[" if @curr_population.generation == 1
	printf "%s", "." if @curr_population.generation % (0.01 * @num_generations) == 0
	puts "]\n" if @curr_population.generation == @num_generations 
  end

  def print_currgen
    puts "#{@curr_population}"  
  end

  # Performs crossover (recombination) operator on two chromosomes
  def crossover(mom, dad, split_pt = rand(mom.chromosome_len)  )
	return [mom, dad] if rand >= @crossover_rate
    puts "performing x-over ..." if @logger
    mom_parts = mom.dissect(split_pt)
    dad_parts = dad.dissect(split_pt) 
    c1 = @chromosome_klass.new(mom_parts[0] + dad_parts[1])
    c2 = @chromosome_klass.new(dad_parts[0] + mom_parts[1])
    #p [c1, c2]
    [c1, c2]
  end

  # Performs selection from the given population and returns
  # a new population consisting of num_members chromosomes 
  def select(pop, num_members = 1)
    puts "performing selection ..." if @logger
    selections = num_members.times.collect { |x| select_roulette(pop) }
    selections
  end

  # Performs "Roulette Wheel" selection whereby probability of selection is
  # proportional to the fitness of individual chromosomes (higher fitness
  # chromosomes have a higher prob. of being selected)
  def select_roulette(pop)
    r = rand(pop.total_fitness + 1) 
    curr_fit_total = 0
    i = 0
    begin
      selected_chromosome = pop[i]
      curr_fit_total += selected_chromosome.fitness
      i += 1
    end while curr_fit_total < r and i < pop.size
    p "selected: #{selected_chromosome}"
    selected_chromosome
  end

  private

  # builds an initial generation of chromosomes from the chromosome class given at construction
  def build_initial_population
    puts "Building initial population of size: #{@population_size} ..." 
    @curr_population = Population.new
    @population_size.times.each { @curr_population << @chromosome_klass.random }
  end

end

