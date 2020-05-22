require 'net/http'

class HTTPLinkFinder

	attr_reader :links_list
	attr_reader :skipped_folder_list
	attr_reader :skipped_file_list

	def initialize
		@links_list = []
		@skipped_folder_list = []
		@skipped_file_list = []

	end

	def FindLinksInFolder(folder_path)

		#Verify folder exists
		#for each file in folder
		#   Is this a folder? recurse File.ftype(file_name)    returns “file'', “directory'', and other strings
		#   Is file .html.md.erb?  File.fnmatch?( pattern, path, [flags] ) → (true or false)click to tog
		#   Determine file Status  File.readable?(file_name) File.size(file_name) 
		#        Add file's BAD Status to BAD Status List
		#   Read File
		#       Collect links in file
		#       Add links in file to links list

	end

	def FindLinksInFile(file_path)
		#Verify file exists
		#Open file   File.open(filename, mode="r" [, opt])
		#If possible collapse file to single line, then check if there are any links
		# look for links:
		#   links can be of form <a href="http.*"> or [display text](http.*)
		#   return all found links

		file_content = ""
		file_link_list = []

		file_content = ReadFileContent(file_path)
		if file_content.length > 0 then
			file_link_list = FindAllLinks(file_content)
			if file_link_list.length > 0 then
				#append all items to the main links list
				@links_list += file_link_list
			end

		end

	end

	def ReadFileContent(file_path)
		exists_result = File.exists?(file_path)
		file_content_raw = []
		file_content = ""

	end

	def FindAllLinks(file_content)


	end


end


class HTTPLinkValidator

	attr_reader :links_list_findings
	attr_reader :links_list_valid
	attr_reader :links_list_invalid

	def initialize
		# a links_lists is either an array (or hash object) with findings entries for each tested URLs
		#  a findings entry is either an array (or hash object) that includes 
		# 		a link URL string 
		# 		source information to log
		# 		validation result message

		@links_list_findings = []
		@links_list_valid = []
		@links_list_invalid = []
	end

	def ValidateAckListLinks(ack_list_file)

		#Verify file exists
		#Read file
		#Convert to valie link_list
		ValidateLinks(link_list)

	end

	def ValidateLinks(link_list)

		link_list.each {|link_item|
			ValidateLink(link_item)
		}

	end

	def ValidateLink(link_item)

		# a link_item is either an arry or a hash object with the following
		# 		a link URL string 
		# 		source information to log

		#puts "\ntesting: #{link_item.to_s}"

		valid_result = false
		link_item_url = link_item[0]
		link_item_source = link_item[1]

		link_item_results = [link_item_url, link_item_source, ""]
		link_item_validation_message = "status: bad link"


		test_uri = URI(link_item_url)
		return_get = Net::HTTP.get(test_uri)
		return_response = Net::HTTP.get_response(test_uri)

		case return_response

			when Net::HTTPSuccess then
				valid_result = true
				link_item_validation_message = "status: valid"

			when Net::HTTPRedirection then
				redirection_location = return_response['location']
				redirection_location2 = redirection_location.sub(/https/, "http")

				if link_item_url == redirection_location || link_item_url == redirection_location2 then
					#puts "BAD LINK"
				else
					#puts "response = redirection: #{redirection_location}"
					valid_result = true
					link_item_validation_message = "status: valid"
				end

			else
				#puts "weirdness: #{return_response.value}"
				link_item_validation_message = "status unknown: #{return_response.value}"
		end

		link_item_results[2] = link_item_validation_message

		links_list_findings.push(link_item_results)
		if valid_result then
			@links_list_valid.push(link_item_results)
		else
			@links_list_invalid.push(link_item_results)

		end

	end


end


class HTTPLinkReplace



end


class TestHarness

	def RunTest0

	end

	def RunTest1
		puts "creating test data"
		test_list = [["https://docs.pivotal.io/pks/1-6/release-notes.html", "test1.html"], ["http://docs.pivotal.io/pks/1-6/releasenotes.html", "test2.html"],["http://docs.pivotal.io/pks/1-7/release-notes.html", "test3.html"]]
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
