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
      best = @curr_population[0]
      puts "Generation: #{generation_count}, best: #{best}"
      if best.respond_to? :max_fitness and best.fitness == best.max_fitness
        puts "Maximal fitness reached ..."
        break
      end
      

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
   
    # selection
    parents = select_sus(num_children,  total_fitness(in_pop), in_pop) 
    
    parents.each_slice(2) do |mom, dad|
    
      # x-over
      children = crossover(mom, dad)

      # mutation
      children.each do |c|
        c.mutate! if rand <= @mutation_rate
        out_pop << c
      end
      
    end
    out_pop
  end

  # Performs crossover (recombination) operator on two chromosomes
  def crossover(mom, dad, split_pt = rand(mom.length))
    raise ArgumentError("cannot perform x-over unless parent chromosomes are the same length!") unless mom.length == dad.length
    m1, m2 = [mom.slice(0, split_pt), mom.slice(split_pt, mom.length)]
    d1, d2 = [dad.slice(0, split_pt), dad.slice(split_pt, dad.length)]
    c1 = @chromosome_klass.random()
    c2 = @chromosome_klass.random()
    c1.set_genes(m1 + d2)
    c2.set_genes(d1 + m2)
    [c1, c2]
  end

  def total_fitness(pop)
    pop.collect { |x| x.fitness }.reduce(:+)
  end
  

  # Performs 'Stochastic Universal Sampling' Algorithm 
  def select_sus(num_sel=1, tf, pop)
    # intialize a table with each member's probability selection weight
    selprob_table = []
    pval = 0
    pop.each_with_index do |x,i|
      pval += x.fitness / tf.to_f
      selprob_table[i] = pval
    end
    
    # march down a list of evenly spaced ptrs that are  1 / num_sel dist
    # away from one another and choose the members of the population whose
    # selection probabilty is defined by that portion of the overall selection
    # probability distribution (see http://www.geatbx.com/docu/algindex-02.html#P416_20744)
    selections = []
    p_sel = 0 
    ptr = rand / num_sel.to_f
    num_sel.times.each  do |i|
      p_sel += 1 while ptr > selprob_table[p_sel]
      selections.push pop[p_sel]  # so maybe 'pop' was a bad variable name?
      ptr += 1 / num_sel.to_f 
    end
    selections
  end

end

