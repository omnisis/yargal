require File.dirname(__FILE__) + '/../lib/yargal'

class TestChromosome < BaseChromosome
  attr_accessor :fitness

  def initialize(fitness = rand(50))
    @fitness = fitness
  end

  def to_s
    puts "{chromosome(#{object_id}) fitness: #{fitness}}"
  end

end

describe "GA Engine" do
  before(:each) do
    @test_population = []
    10.times { @test_population << TestChromosome.new }
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
    ga.chromosome_len.should eql 32
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
      return times_selected.to_f / selected_gen.size
    end


    it "should favor highest fitness chromosomes" do
      @test_population << TestChromosome.new(LARGE_FITNESS)
      selrate = calc_selection_rate(LARGE_FITNESS)
      (selrate > 0.75).should be_true
    end

    it "should not favor lower fitness chromosomes" do
      @test_population << TestChromosome.new(SMALL_FITNESS)
      selrate = calc_selection_rate(SMALL_FITNESS)
      (selrate < 0.25).should be_true
    end


  end

end

