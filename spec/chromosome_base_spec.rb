require File.dirname(__FILE__) + '/../lib/chromosome_base'
require File.dirname(__FILE__) + '/spec_helper'

include YargalSpecHelper

describe "BaseChromosome" do

  it "should create a random sequence on init" do
    c = TestChromosome.random(20)
    c.chromosome_len.should  eql 20 
    c.size.should  eql 20
    num_zero_or_ones = c.find_all { |x| x == "0" || x == "1" }.size
    num_zero_or_ones.should eql 20
  end

  it "can build chromosome from a binary string" do
    c = TestChromosome.new("1100100001")
    c.chromosome_len.should eql 10
    c[0..9].join.should eql "1100100001"
  end

  it "can build chromosome from array of num" do
    c = TestChromosome.new([1,2,3,4,5])
    c.size.should eql 5
    c[0..4].join.should eql "12345"
  end

  it "can build chromosome from array of str" do
    c = TestChromosome.new(["one", "two", "three", "four"])
    c.size.should eql 4
    c[0..3].join.should eql "onetwothreefour"
  end

end
