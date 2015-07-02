require 'rspec'
require './pattern_hunter'


describe PatternHunter do
	describe "#initialize" do
	  it "makes a new PatternHunter" do
	  	x = Time.new
	  	bob = PatternHunter.new 'bob'
	  	y = Time.new
	  	expect(bob.name).to eq 'bob'
	  	expect(bob.birth_moment).to be > x
	  	expect(bob.birth_moment).to be < y
	  end
	end
	
  describe '#display_patterns' do
    it "displays the stored patterns" do
    	
    end
  end
end