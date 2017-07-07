require 'json'
require 'octokit'
require 'open-uri'
require 'nokogiri'

@current_pcf_version_number = ENV['CURRENT_PCF_VERSION_NUMBER']
@starting_windows_stemcell_version = ENV['STARTING_WINDOWS_STEMCELL_VERSION']

@client = Octokit::Client.new :access_token => ENV['STEMCELL_RN_BOT_GIT_TOKEN']

hash = {
  :om => ['ops-manager', 'opsmanager-rn.html'],
  :ert => ['elastic-runtime', 'runtime-rn.html'],
  :ist => ['isolation-segment', 'segment-rn.html'],
  :wrt => ['runtime-for-windows', 'windows-rn.html'],
  :wsc => ['stemcells-windows-server', 'windows-stemcell-rn.html']
}

def get_releases(url)

  #get and parse the list of releases from pivnet
  releases = URI.parse(url).read
  releases = JSON.parse(releases) 
  releases_list = releases['releases']

  #put the list of releases in order of their version numbers
  sorted_releases_list = releases_list.sort_by { |h| h['version'] }.reverse

  right_releases = sorted_releases_list.select do |d|
    d['version'].start_with?(url.include?("windows-server") ? "#{@starting_windows_stemcell_version[0..1]}" : "#{@current_pcf_version_number}")
  end

  numbers_list = right_releases.map do |r| 
    r['version']
  end

  return numbers_list

end

def scan_release_notes(url)
  rn = Nokogiri::HTML(open(url))
  rn_list = []

  header = url.include?("windows-stemcell-rn") ? "h2" : "h3" 

  #grab the list of H3 headers from the release notes 
  rn.xpath("//#{header}").each do |i|
    rn_list.push(i.text.strip)
  end

  #find the first header we care about
  if url.include?("windows-stemcell-rn")
    index_of_start = rn_list.index do |d|
      d == "#{@starting_windows_stemcell_version}.1"
    end
  else
    index_of_start = rn_list.index do |d|
      d == "#{@current_pcf_version_number}.0"
    end
  end

  #just the ones we want
  releases_full = rn_list[0..index_of_start]
end

def start(hash)
  hash.each do |k,v|
    a = get_releases("https://network.pivotal.io/api/v2/products/#{v[0]}/releases")
    b = scan_release_notes("https://docs.pivotal.io/pivotalcf/1-11/pcf-release-notes/#{v[1]}")
    create_issue(v[0], a - b) if a != b
  end
end

def create_issue(product, version)
  @client.create_issue("pivotal-cf/pcf-release-notes", "Missing Release Note for #{product} #{version}", "The **#{product}** release notes are missing version #{version}. This has been a notification from the Release Checker Bot.", {:ref => @current_pcf_version_number})
end