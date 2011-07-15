YARGAL: Yet Another Ruby Genetic Algorithm Library
================

YARGAL is a very simplistic Genetic Algorithm Library written in Ruby.  Currently YARGAL
uses [Fitness Proportionate Selection](http://en.wikipedia.org/wiki/Fitness_proportionate_selection) coupled with a single-point
crossover operator.  Elitism is also employed to preserve the best chromosomes from the previous population.  
YARGAL stands for *Y*et*A*nother*R*uby*G*enetic*A*lgorithm*L*ibrary.

How do I use it?
----------

It's easy to get started with YARGAL

### Create a Chromosome class that extends ChromosomeBase

	class MyChromosome < ChromosomeBase
   
    	def self.random()
    	... code to generate a new random chromosome ...
		end

    	def calc_fitness
    	... code to set / return a fitness value for this chromosome ...
		end
    
    	def mutate!
		... code to mutate your chromosome ...
    	end
    
 	end


If all this seems to confusing.  Take a look at the mystery_word.rb example in the
**examples** directory.
  

### Intialize and configure the GA Engine
The GAEngine itself is configured with the class of your chromosome and a simple hash
of all the options you'd like to set.  For example:


	@ga = GA.new(MyChromosome, {:population_size => 100, :mutation_rate => 50})


### Call *GA.evolve()* to start evolving a population
Finally you call *GA.evolve!()* with a parameter indicating the number of iterations that you'd like
to perform for example:
	
	@ga.evolve!(500)


Future Improvements
--------

This code is very basic right now.  I would like to improve it in a variety of ways by adding different selection
algorithms, different crossover operators and potentially turning the library into a true rubygem.

Disclaimer
--------

This code is pre-alpha state and was developed for my own enjoyment.  Enjoy!
