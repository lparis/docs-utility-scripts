require_relative 'httplinfinder.rb'
require_relative 'httplinkvalidator.rb'
require_relative 'httplinkreplacer.rb'

class TestHarness

	def RunTest0

	end

	def RunTest1
		puts "creating test data"
		test_list = [["https://docs.pivotal.io/pks/1-6/release-notes.html", "test1.html"], ["http://docs.pivotal.io/pks/1-6/Xreleasenotes.html", "test2a.html"],["https://docs.pivotal.io/pks/1-6/Xreleasenotes.html", "test2b.html"],["http://docs.pivotal.io/pks/1-7/release-notes.html", "test3.html"]]
		validation_tester1 = HTTPLinkValidator.new

		puts "starting tests"
		validation_tester1.ValidateLinks(test_list)
		puts "test completed: #{validation_tester1.links_list_findings.to_s}"

	end

	def RunTest2
		#what does a linux path look like? use expand_path to determine a file's full path

		puts "test file"
		exists_result = File.exists?("../../../temp/findme.txt")
		puts "exists_result: #{exists_result}"
		exists_path = File.expand_path("../../../temp/findme.txt")           #=> "/home/oracle/bin"
		puts "expanded path: #{exists_path}"
		#  returns: "expanded path: /Users/olivergraves/temp/findme.txt"
	end


end


tester1 = TestHarness.new
tester1.RunTest1
