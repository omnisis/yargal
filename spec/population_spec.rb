require File.dirname(__FILE__) + '/../lib/chromosome_base'
require File.dirname(__FILE__) + '/../lib/population'
require File.dirname(__FILE__) + '/spec_helper'

include YargalSpecHelper

describe "Population" do

  before(:each) do
    @c1 = TestChromosome.random(10)
    @c2 = TestChromosome.random(10)
    @c3 = TestChromosome.random(10)
    @c4 = TestChromosome.random(10)
    @test_chromosomes = [@c1,@c2, @c3, @c4]
    @pop = Population.new()
    @test_chromosomes.each { |c| @pop << c }
    @test_fitscores = @test_chromosomes.collect { |c| c.evaluate_fitness }
    @exp_total_fitness = @test_fitscores.reduce(:+)
    @pop.calc_fitness
  end

  it "should properly calculate total fitness" do
    @pop.total_fitness.should eql @exp_total_fitness
  end

  it "should calc mean fitness based on chromosomes" do
    @pop.mean_fitness.should eql @exp_total_fitness.to_f / @test_chromosomes.size
  end

  it "should return fitness scores of last evaluation" do
    scores = @test_chromosomes.collect { |c| c.evaluate_fitness }
    scores.should eql @test_fitscores
  end

  it "should update fitness all chromosomes" do
    @test_chromosomes.each do |c|
      (c.fitness > 0).should be_true
    end
  end



end
