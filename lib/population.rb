#####
# represents a population of chromosomes
#####
class Population  < Array
  attr_reader :total_fitness
  attr_accessor :generation
  
  def initialize
    @total_fitness = 0
    @last_gen = nil
    @generation = 0
  end

  # Goes thru the entire population recalculating everyone's fitness
  # and updating the total_fitness of the population
  def calc_fitness
    @total_fitness = 0
    @last_gen = self.generation
    self.each do |x|  
      currfit = x.evaluate_fitness
      x.fitness = currfit
      @total_fitness += x.fitness
    end
  end
  
  def self.from_a(arry)
	p = Population.new
	arry.each { |x| p << x}
	p
  end
  

  # Mean fitness of the entire population
  def mean_fitness
    calc_fitness if @last_gen.nil? or @last_gen != self.generation
    total_fitness.to_f / self.size
  end

  def most_fit(n=1)
    self.sort_by { |x| x.fitness}.reverse.slice(0,n)
  end

  def least_fit(n=1)
    self.sort_by { |x| x.fitness}.slice(0,n)
  end

  def to_s
    puts "<<<<<<<[  Generation: #{self.generation} ]<<<<<<<<<<<<<<<<<"
    self.each { |member| puts "member:: #{member}" }
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end

  def inspect
    to_s
  end

end
