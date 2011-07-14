require File.dirname(__FILE__) + '/../lib/yargal'
require File.dirname(__FILE__) + '/../examples/mystery_word'
  

#####
# Engine tests
#####
describe "GA Engine" do
  before(:each) do
    @ga = GA.new(MysteryWord)
    @test_population = []
    @most_fit = MysteryWord.new("camelos")
    @least_fit = MysteryWord.new("zzzzzzz")
    @test_population << MysteryWord.new("baeelou")
    @test_population << MysteryWord.new("asdjdsa")
    @test_population << MysteryWord.new("camezzz") 
    @test_population << @most_fit << @least_fit
    @test_population.each { |x| x.calc_fitness }
    @test_population.sort!{ |a, b| a.fitness <=> b.fitness}
  end

  it "should have sane defaults" do:w
    @ga.mutation_rate.should   eql GA::DEFAULTS[:mutation_rate]
    @ga.population_size.should eql GA::DEFAULTS[:population_size]
  end

  it "should properly parse setup options" do
    options = { :chromosome_len => 32, :population_size => 10, :mutation_rate => 0.2 }
    ga = GA.new(MysteryWord, options)
    ga.population_size.should eql 10
    ga.mutation_rate.should eql 0.2
  end


  #####
  # crossover tests
  #####
  describe "crossover operation" do
    it "should mix dna of both parents" do
      mom = MysteryWord.new("bamolot")
      dad = MysteryWord.new("camisal")
      child = @ga.crossover(mom,dad, 3)
      child.join.should eql "bamisal"
    end
  end

  #######
  # roulette selection
  #######
  describe "roulette selection" do
    
    def calc_selection_rate(pop, chromosome)
      selmap = {}
      1000.times do
        selection = @ga.select_roulette(@test_population)
        if selmap[selection].nil?
          selmap[selection] = 0
        end 
        selmap[selection] += 1 
      end
      total_selections = selmap.values.reduce(:+)
      selmap[chromosome] / total_selections.to_f
    end

    it "should favor highest fitness chromosomes" do
      selrate = calc_selection_rate(@test_population, @most_fit)
      (selrate > 0.75).should be_true
    end

    it "should not favor lower fitness chromosomes" do
      selrate = calc_selection_rate(@test_population, @least_fit)
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

    it "should evolve a maximal solution" do
      @ga = GA.new(MysteryWord, { :population_size => 1000, :mutation_rate => 0.25, :elitism_rate => 0.10 })
      @ga.evolve!(30)
      @ga.curr_population[0].fitness.should == 2.0
    end

  end


  describe "mystery word" do
    it "should have a good fitness func" do
      w1 = MysteryWord.new("camelot")
      w2 = MysteryWord.new("camelop")
      w3 = MysteryWord.new("hameloa")
      w4 = MysteryWord.new("dafefgp")
      w5 = MysteryWord.new("zzzgggg")
      words = [w1,w2,w3,w4,w5]
      #words.each { |x| x.calc_fitness; puts "word: #{x}" }
    end
  end

end
