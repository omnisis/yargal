require File.dirname(__FILE__) + '/../lib/chromosome_base'

describe "BaseChromosome" do

  it "should create a random sequence on init" do
    c = ChromosomeBase.new(20)
    c.chromosome_len.should  == 20 
    c.size.should  == 20
    num_zero_or_ones = c.find_all { |x| x == 0 || x == 1 }.size
    num_zero_or_ones.should == 20
  end

  it "gene sequence matches internal representation" do
    c = ChromosomeBase.new(10, "1100100001")
    str_rep = c.gene_seq
    str_rep.include?("1100100001").should be_true
  end

  it "should extract genes of an arbitrary length" do
    c = ChromosomeBase.new(10, "1100100001")
    genes = c.extract_genes(3)
    genes[0].should eql "110"
    genes[1].should eql "010"
    genes[2].should eql "000"
    genes[3].should eql "1"
  end

end
