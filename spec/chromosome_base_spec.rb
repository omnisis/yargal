require File.dirname(__FILE__) + '/../lib/chromosome_base'

class TestChromosome < ChromosomeBase
    DEFAULT_LEN = 10

    def initialize(word)
      word.each {|c| self << c.to_s }
    end

    # generate a new chromosome with gene length ==  DEFAULT_LEN
    def self.random(len = DEFAULT_LEN)
      rand_genes = []
      len.times.each do
        rand_genes << rand(2).to_s
      end
      c = TestChromosome.new(rand_genes)
      rand_genes = len.times.collect { rand(2).to_s }
      c.set_genes(rand_genes)
      c
    end

    # fitness is the binary value of our gene sequence
    def calc_fitness
      self.join.to_i(2)
    end

    def mutate!
      mpos1 = rand(self.size)
      self[mpos1] = (self[mpos1].to_i(2) == 0) ? 1: 0
    end

  end

describe "BaseChromosome" do
  before(:each) do
    @test_chromosome = TestChromosome.random()
  end

  it "should create a random sequence on init" do
    @test_chromosome.size.should  equal TestChromosome::DEFAULT_LEN
    num_zero_or_ones = @test_chromosome.find_all { |x| x == "0" || x == "1" }.size
    num_zero_or_ones.should equal TestChromosome::DEFAULT_LEN
  end

  it "can build chromosome from a binary string" do
    @test_chromosome.set_genes("1100100001".chars.to_a)
    @test_chromosome.size.should ==  10
    @test_chromosome.join.should == "1100100001"
  end

  it "can build chromosome from array of num" do
    @test_chromosome.set_genes([1,2,3,4,5])
    @test_chromosome.size.should == 5
    @test_chromosome.join.should == "12345"
  end

  it "can build chromosome from array of str" do
    @test_chromosome.set_genes(["one", "two", "three", "four"])
    @test_chromosome.size.should == 4
    @test_chromosome.join.should == "onetwothreefour"
  end

  it "should mutate" do
    oldval = @test_chromosome.join.to_s
    @test_chromosome.mutate!
    @test_chromosome.join.to_s.should_not == oldval
  end
end
