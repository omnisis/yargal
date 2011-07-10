#####
# Base class for a chromosome.  Internally a chromosome is represented as 
# an arbitrary length array. 
##### 
class ChromosomeBase < Array
  attr_accessor  :chromosome_len, :fitness
  DEFAULT_MUTATION_RATE = 0

  # if an existing gene_seq is supplied is supplied use it
  # otherwise generate a random bit string of length len
  def initialize(gene_sequence = [])
    gene_sequence.length.times do |i|
      self << gene_sequence[i]
    end
    @fitness = 0.0
  end

  alias :chromosome_len :size

  def to_s
    fitstr = format("%8.8g", self.fitness.to_f)
    "{ gene sequence: #{gene_seq}, fitness: #{fitstr} }"
  end

  def inspect
    to_s
  end

  def evaluate_fitness
    raise NotImplementedError.new('must provide evaluate_fitness method!')
  end

  # Returns a stringified representation of this chromosome's genes
  def gene_seq
    "[" + self.collect { |x| x.to_s }.join('-') + "]"
  end

end
