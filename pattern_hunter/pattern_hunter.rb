require 'yaml'

class PatternHunter
	attr_accessor :files, :birth_moment, :name
	def initialize name
		@files = []
		@name = name
		@birth_moment = Time.new
		@patterns = []
		@active_patterns
	end

	def load_patterns save_yml

	end

	def add_pattern

	end

	def display_patterns

	end

	def active_patterns
		@active_patterns
	end

	def process file
		matches = []
		active_patterns.each { |ap| file.scan ap }
	end

	def hunt glob
		
		@files = Dir.glob glob
		results = files.map{|file| process file }
	end

end

bob = PatternHunter.new bob

bob.hunt '~/workspace/**/*config*.html*'
p bob.files
p bob.birth_moment