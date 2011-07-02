#####
# Base class for a chromosome.  Internally a chromosome is represented as 
# an arbitrary length bitstring.
##### 
class ChromosomeBase < Array
  attr_accessor :fitness, :chromosome_len
  FITNESS_UNKNOWN = -1

  # if an existing gene_seq is supplied is supplied use it
  # otherwise generate a random bit string of length len
  def initialize(len = 32, gene_sequence = nil)
    (0..len-1).each { |n| 
      self << gene_sequence[n] unless gene_sequence.nil?
      self << rand(2) if gene_sequence.nil?
    }
    @fitness = FITNESS_UNKNOWN 
  end

  alias :chromosome_len :size

  def evaluate_fitness
    raise NotImplementedError.new("You must implement evaluate_fitness!")
  end

  def to_s
    "chromsome_len: #{chromosome_len}, fitness: #{fitness}, gene sequence: #{gene_seq}"
  end

  # Returns a stringified representation of this chromosome's genes
  def gene_seq
    str = "[["
    self.each { |x| str += x.to_s }
    str += "]]"
  end

  # given a gene length, splits gene sequence into groups of genes each
  # of size gene_len 
  def extract_genes(gene_len)
    genes = []
    self.each_slice(gene_len) { |slice| genes << slice.join }
    genes
  end

end
