require File.dirname(__FILE__) + '/../lib/yargal'
require File.dirname(__FILE__) + '/spec_helper'

include YargalSpecHelper

describe "GA Engine" do
  before(:each) do
    @test_population = Population.new()
    10.times { @test_population << TestChromosome.new(rand(101)) }
  end

  it "should have sane defaults" do
    ga = GA.new(TestChromosome)
    ga.crossover_rate.should  eql 0.7
    ga.mutation_rate.should   eql 0.001
    ga.population_size.should eql 50
  end

  it "should properly parse setup options" do
    options = { :chromosome_len => 32, :population_size => 10, :crossover_rate => 0.5, :mutation_rate => 0.2 }
    ga = GA.new(TestChromosome, options)
    ga.population_size.should eql 10
    ga.crossover_rate.should eql 0.5
    ga.mutation_rate.should eql 0.2
  end

  pending "should perform crossover" do
  end

  pending "should perform mutation" do
  end

  pending "should perform selection" do
  end

  describe "roulette selection" do
    LARGE_FITNESS = 500
    SMALL_FITNESS = 5

    before(:each) do
      @ga = GA.new(TestChromosome, { :population_size => 1000})
      @test_population.clear
      @test_population << TestChromosome.new(17)
      @test_population << TestChromosome.new(15)
      @test_population << TestChromosome.new(14)
      @test_population << TestChromosome.new(18)
    end

    def calc_selection_rate(tgt_fitness)
      selected_gen = []
      @ga.population_size.times do
        selected_gen << @ga.select_roulette(@test_population)
      end
      times_selected = selected_gen.find_all { |x| x.fitness == tgt_fitness }.size
      rate = times_selected.to_f / selected_gen.size
      puts "selrate: #{rate}"
      rate
    end

    it "should favor highest fitness chromosomes" do
      @test_population << TestChromosome.new(LARGE_FITNESS)
      @test_population.calc_fitness
      selrate = calc_selection_rate(LARGE_FITNESS)
      puts "selection rate:" #{selrate}"
      (selrate > 0.75).should be_true
    end

    it "should not favor lower fitness chromosomes" do
      @test_population << TestChromosome.new(SMALL_FITNESS)
      selrate = calc_selection_rate(SMALL_FITNESS)
      (selrate < 0.25).should be_true
    end

  end

end
