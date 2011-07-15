require File.dirname(__FILE__) + '/../lib/yargal'
require File.dirname(__FILE__) + '/../examples/mystery_word'
  

#####
# Engine tests
#####
describe "GA Engine" do
  before(:each) do
    @ga = GA.new(MysteryWord, {:population_size => 3000, :mutation_rate => 0.25})
    @test_population = []
    @most_fit = MysteryWord.new("Hello World!")
    @least_fit = MysteryWord.new("zzzzz aaaaaa")
    @test_population << MysteryWord.new("Hella Worlh!")
    @test_population << MysteryWord.new("Bella Wurld!")
    @test_population << MysteryWord.new("Sello World!") 
    @test_population << @most_fit << @least_fit
    @test_population.each { |x| x.calc_fitness }
    @test_population.sort!{ |a, b| b.fitness <=> a.fitness}
  end

  it "should properly parse setup options" do
    options = { :population_size => 10, :mutation_rate => 0.2 }
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
      children = @ga.crossover(mom,dad, 3)
      children[0].join.should eql "bamisal"
      children[1].join.should eql "camolot"
    end
  end

  
  #######
  # sus selection
  #######
  describe "sus selection" do
    
    def calc_selection_rate(pop, chromosome)
      selmap = {}
      tf = @test_population.collect { |x| x.fitness}.reduce(:+)
      selections = @ga.select_sus(5000, tf, @test_population)
      selections.each do |x|
        selmap[x] = 1 if not selmap.has_key?(x)
        selmap[x] += 1 
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
      @ga = GA.new(MysteryWord, { :population_size => 2000, :mutation_rate => 0.25, :elitism_rate => 0.10 })
      @ga.evolve!(50)
      @ga.curr_population[0].fitness.should  be_within(1.0).of(2.0)
    end

  end


  describe "mystery word" do
    it "should have a good fitness func" do
      w1 = MysteryWord.new("hello world!")
      w2 = MysteryWord.new("hella world!")
      w3 = MysteryWord.new("bella worlds")
      w4 = MysteryWord.new("doodo world!")
      w5 = MysteryWord.new("abcde fghijk")
      words = [w1,w2,w3,w4,w5]
      #words.each { |x| x.calc_fitness; puts "word: #{x}" }
    end
  end

end
