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

