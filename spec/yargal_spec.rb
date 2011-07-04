require File.dirname(__FILE__) + '/../lib/yargal'
require File.dirname(__FILE__) + '/spec_helper'

include YargalSpecHelper

LARGE_FITNESS = 500
SMALL_FITNESS = 5

#####
# Engine tests
#####
describe "GA Engine" do
  before(:each) do
    @ga = GA.new(TestChromosome)
    @test_population = Population.new
    @most_fit = TestChromosome.with_fitness(LARGE_FITNESS)
    @least_fit = TestChromosome.with_fitness(SMALL_FITNESS)
    @test_population << @most_fit << @least_fit 
    @test_population << TestChromosome.with_fitness(50) << TestChromosome.with_fitness(35)
  end

  it "should have sane defaults" do
    @ga.crossover_rate.should  eql 0.7
    @ga.mutation_rate.should   eql 0.001
    @ga.population_size.should eql 50
  end

  it "should properly parse setup options" do
    options = { :chromosome_len => 32, :population_size => 10, :crossover_rate => 0.5, :mutation_rate => 0.2 }
    ga = GA.new(TestChromosome, options)
    ga.population_size.should eql 10
    ga.crossover_rate.should eql 0.5
    ga.mutation_rate.should eql 0.2
  end


  #####
  # crossover tests
  #####
  describe "crossover operation" do
    it "should mix dna of both parents" do
      mom = TestChromosome.new("1010111")
      dad = TestChromosome.new("0011110")
      kid1, kid2 = @ga.crossover(mom,dad, 3)
      kid1.join.should eql "1011110"
      kid2.join.should eql "0010111"
    end
  end

  pending "should perform mutation" do
  end

  pending "should perform selection" do
  end

  describe "roulette selection" do

    def calc_selection_rate(chromosome)
      selected_gen = Population.new
      @ga.population_size.times do
        puts "adding new selection"
        selected_gen << @ga.select_roulette(@test_population)
      end
      puts "selected generation: #{selected_gen}"
      times_selected = selected_gen.select { |x| x  == chromosome }.size
      puts "times selected: #{times_selected}"
      rate = times_selected.to_f / selected_gen.size
      rate
    end

    it "should favor highest fitness chromosomes" do
      @test_population.calc_fitness
      selrate = calc_selection_rate(@most_fit)
      (selrate > 0.75).should be_true
    end

    it "should not favor lower fitness chromosomes" do
      @test_population.calc_fitness
      selrate = calc_selection_rate(@least_fit)
      (selrate < 0.25).should be_true
    end

  end

  ####
  # Evolution tests
  ####
  describe "evolution" do
    it "should create a new population" do
      @ga.evolve!
    end

    it "should evolve continuosly"  do
      @ga.evolve!(500)
    end

  end

end
