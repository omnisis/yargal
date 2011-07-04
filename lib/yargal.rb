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
    @crossover_rate = options[:crossover_rate] || 0.7
    @mutation_rate = options[:mutation_rate] || 0.001
    @population_size = options[:population_size] || 50
    @logger = options[:logger] if options[:logger]
    @chromosome_length = options[:chromosome_length] || 10
    @chromosome_klass = chromosome_klass
    @generation_count = 0
    build_initial_population
  end

  # evolves our population thru a series of generations
  def evolve!(num_generations = 1)
    num_generations.times do
      perform_evolution!
    end
    print_currgen
  end

  def perform_evolution!()
    puts "calculating fitness ..."
    @curr_population.calc_fitness
    print_stats

    new_pop = Population.new()
    @curr_population.in_groups_of(2) do 
      #puts "slice: #{slice}"
      mom, dad = @curr_population.sample(2)
      #puts "mom: #{mom}, dad: #{dad}"
      children =  crossover(mom, dad)
      mutate!(children) # x-men first class!
      #puts "children: #{children[0]}, #{children[1]}"
      new_pop << children[0] << children[1]
      #puts "newpop: #{new_pop}"
    end
    puts "newpop size: #{curr_population.size}"

    @curr_population = Population.new
    new_pop.each { |x| @curr_population << x }
    @generation_count += 1
  end

  def print_stats
    puts "------------------------------------------------------------------------"
    puts "generation [#{generation_count}] -- " +
          "mean fitness [#{@curr_population.mean_fitness}] -- " +
          "total fitness [#{@curr_population.total_fitness}]"
    #puts @curr_population
    puts "------------------------------------------------------------------------"
  end

  def print_currgen
    #puts @curr_population
  end

  # Performs crossover (recombination) operator on two chromosomes
  def crossover(mom, dad, split_pt = rand(mom.chromosome_len)  )
    mom_parts = mom.dissect(split_pt)
    dad_parts = dad.dissect(split_pt) 
    c1 = @chromosome_klass.new(mom_parts[0] + dad_parts[1])
    c2 = @chromosome_klass.new(dad_parts[0] + mom_parts[1])
    #p [c1, c2]
    [c1, c2]
  end

  # Performs mutation operator on two chromosomes
  def mutate!(children)
    #TODO: implement this
    return children
  end

  # Performs selection from the given population and returns
  # a new population consisting of num_members chromosomes 
  def select(pop, num_members = 1)
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

