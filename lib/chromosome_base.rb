#
# Base class for a chromosome.  Internally a chromosome is represented as 
# an arbitrary length array. 
#
class ChromosomeBase < Array
  attr_accessor  :fitness

  def initialize
    @fitness = 0
  end

  def to_s
    "{ gene sequence: #{gene_seq}, fitness: #{fitness} }"
  end

  def calc_fitness
    raise NotImplementedError.new('must provide calc_fitness method!')
  end

  def self.random()
    raise NotImplementedError.new('must provide singleton method random()')
  end

  def set_genes(new_genes=[])
    self.clear
    new_genes.each { |gene| self << gene }
  end
  
  def mutate!
    raise NotImplementedError.new('must provide a mutate() method!')
  end

  # Returns a stringified representation of this chromosome's genes
  def gene_seq
    "[" + self.collect { |x| x.to_s }.join('|') + "]"
  end

end
