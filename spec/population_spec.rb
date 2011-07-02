require File.dirname(__FILE__) + '/../lib/chromosome_base'
require File.dirname(__FILE__) + '/../lib/population'
require File.dirname(__FILE__) + '/spec_helper'

include YargalSpecHelper

describe "Population" do

  before(:each) do
    @c1 = TestChromosome.new(10)
    @c2 = TestChromosome.new(10)
    @c3 = TestChromosome.new(10)
    @c4 = TestChromosome.new(10)
    @test_chromosomes = [@c1,@c2, @c3, @c4]
    @pop = Population.new()
    @test_chromosomes.each { |c| @pop << c }
    @test_fitscores = []
    @test_chromosomes.each { |c| @test_fitscores << c.evaluate_fitness }
    @pop.calc_fitness
  end

  it "should properly calculate total fitness" do
    @pop.total_fitness.should eql @test_fitscores.reduce(:+)
  end

  it "should calc mean fitness based on chromosomes" do
    @pop.mean_fitness.should eql @test_fitscores.reduce(:+).to_f / @test_chromosomes.size
  end

  it "should return fitness scores of last evaluation" do
    @test_chromosomes.each { |c| 
      found = @pop.fitness_scores.find { |x|  x == c.evaluate_fitness }
      found.nil?.should be_false
    }
  end



end
