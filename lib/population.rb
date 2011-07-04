#####
# represents a population of chromosomes
#####
class Population  < Array
  attr_reader :total_fitness 
  
  def initialize
    @total_fitness = 0
    @last_size = -1
  end

  # Goes thru the entire population recalculating everyone's fitness
  # and updating the total_fitness of the population
  def calc_fitness
    @last_size = self.size
    self.each do |x|  
      currfit = x.evaluate_fitness
      x.fitness = currfit
      @total_fitness += x.fitness
    end
  end

  # Mean fitness of the entire population
  def mean_fitness
    calc_fitness if @last_size == -1 or @last_size != self.size
    total_fitness.to_f / self.size
  end

end
