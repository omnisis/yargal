#####
# represents a population of chromosomes
#####
class Population < Array
  attr_reader :total_fitness, :fitness_scores

  # Goes thru the entire population recalculating everyone's fitness
  # and updating the total_fitness of the population
  def calc_fitness
    raise "Population is empty!  Did you add chromosomes to it?" if self.size == 0
    @fitness_scores = self.collect { |x| x.evaluate_fitness }
    @total_fitness = @fitness_scores.inject { |memo, n| memo + n }
  end

  # Mean fitness of the entire population
  def mean_fitness
    raise "Population is empty!  Did you add chromosomes to it?" if self.size == 0
    total_fitness.to_f / self.size
  end

end
