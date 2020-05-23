require 'net/http'


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
			ValidateLinkInfo(link_item)
		}

	end


	def ValidateLinkInfo(link_item)

		# a link_item is either an arry or a hash object with the following
		# 		a link URL string 
		# 		source information to log

		#puts "\ntesting: #{link_item.to_s}"

		valid_result = false
		link_item_url = link_item[0]
		link_item_source = link_item[1]

		link_item_results = ValidateLink(link_item_url, link_item_source)

		links_list_findings.push(link_item_results)
		if valid_result then
			@links_list_valid.push(link_item_results)
		else
			@links_list_invalid.push(link_item_results)

		end

	end

	def ValidateLink(link_item_url, link_item_source)

		# a link_item is either an arry or a hash object with the following
		# 		a link URL string 
		# 		source information to log

		#puts "\ntesting: #{link_item.to_s}"

		error_raised = true
		link_item_results = [link_item_url, link_item_source, ""]
		link_item_validation_message = "status: bad link"

		begin
			test_uri = URI(link_item_url)
			return_get = Net::HTTP.get(test_uri)
			return_response = Net::HTTP.get_response(test_uri)
			error_raised = false
		
		rescue Net::HTTPServerError 
			link_item_validation_message = "status HTTPServerError: "
			#link_item_validation_message remains "status: bad link"
			puts "HTTPServerError"

		rescue Net::HTTPServerException then
			link_item_validation_message = "status HTTPServerException: "
			puts "HTTPServerException"

		rescue StandardError => msg
			link_item_validation_message = "status unhandled error raised: #{msg}"
			puts "unhandled error raised: #{msg}"

		rescue
			puts "keep looking for error types!"	
		end
			
		if !error_raised then

			puts "response = #{return_response}: #{link_item_url}"
			case return_response

				when Net::HTTPOK then
					valid_result = true
					link_item_validation_message = "status: HTTPOK"

				when Net::HTTPSuccess then
					valid_result = true
					link_item_validation_message = "status: HTTPSuccess"

				when Net::HTTPNotFound then
					link_item_validation_message = "status HTTPNotFound: "

				when Net::HTTPRedirection then
					redirection_location = return_response['location']
					redirection_location2 = redirection_location.sub(/https/, "http")

					puts "response = #{return_response} \nredirection: #{redirection_location}"
					if link_item_url == redirection_location then
						#bad link

					elsif link_item_url == redirection_location2 then
						valid_result = true
						link_item_validation_message = "status: valid - http/https"
					else
						#puts "response = redirection: #{redirection_location}"
						valid_result = true
						link_item_validation_message = "status: valid"
					end

				when Net::HTTPServerError then
					link_item_validation_message = "status HTTPServerError: "

				when Net::HTTPMovedPermanently then
					#link_item_validation_message remains "status: bad link"

				when Net::HTTPServerException then
					#link_item_validation_message remains "status: bad link"

				else
					#puts "weirdness: #{return_response.value}"
					link_item_validation_message = "status unknown:  #{return_response.to_s}"
			end
		
		end

		link_item_results[2] = link_item_validation_message

		return link_item_results

	end


end

