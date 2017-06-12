require 'json'
require 'octokit'
require 'open-uri'
require 'base64'
require_relative 'update-stemcell-rn'

@starting_stemcell_version = ENV['STARTING_STEMCELL_VERSION']
@current_pcf_version_number = ENV['CURRENT_PCF_VERSION_NUMBER']
@client = Octokit::Client.new :access_token => ENV['STEMCELL_RN_BOT_GIT_TOKEN']
@stemcell_json_file = @client.contents('pivotal-cf-experimental/docs-utility-scripts', {:path => 'stemcell-rn-bot/stemcell-releases.json'})
@bosh_repo_name = ENV['BOSH_REPO_NAME']

def get_stemcells_json

  # grab current stemcell json file
  stemcell_json_contents = @stemcell_json_file['content']
  return Base64.decode64(stemcell_json_contents)

end

def put_stemcells_json(content)

  # update the stemcell release notes
  @client.update_contents('pivotal-cf-experimental/docs-utility-scripts',
                 "stemcell-rn-bot/stemcell-releases.json",
                 "Stemcell RN Bot automatically updating stemcell-releases.json",
                 @stemcell_json_file['sha'],
                 content, :branch => @current_pcf_version_number)
end

def get_stemcells_pivnet

  #get and parse the list of stemcell releases from pivnet
  stemcells = URI.parse('https://network.pivotal.io/api/v2/products/stemcells/releases').read
  stemcells = JSON.parse(stemcells) 
  stemcells_list = stemcells['releases']

  #put the list of stemcells in order of their version numbers
  sorted_stemcells_list = stemcells_list.sort_by { |h| h['version'] }.reverse

  right_stemcells = sorted_stemcells_list.select do |d|
    d['version'].start_with?("#{@starting_stemcell_version}")
  end

  stemcells_numbers_list = right_stemcells.map do |r| 
    r['version']
  end

  return stemcells_numbers_list

end

def get_stemcells_github

  # instantiate the bosh repo as a repository object
  bosh_repo = Octokit::Repository.from_url(@bosh_repo_name)

  # grab the list of releases
  bosh_releases = @client.releases(bosh_repo)

  # filter only stemcell releases
  stemcell_releases_full = bosh_releases.select do |r| 
    r[:name].start_with?("Stemcell") 
  end

  # get index of starting stemcell
  index_of_starting_stemcell = stemcell_releases_full.index do |d|
    d[:name] == "Stemcell #{@starting_stemcell_version}"
  end

  # just the ones we want
  stemcell_releases_full = stemcell_releases_full[0..index_of_starting_stemcell]

  # then a smaller slice of the stemcells on pivnet, plus the 'base' stemcell
  stemcell_releases_slice = []
  get_stemcells_pivnet.each do |n|
    stemcell_releases_full.each do |s|
      stemcell_releases_slice.push(s) if s[:name] == "Stemcell #{n}"
    end
  end

  stemcell_releases_slice.push(stemcell_releases_full[index_of_starting_stemcell])

  # filter only name, date, and body info into new hash
  stemcell_releases = []
  stemcell_releases_slice.each do |d|
    new_hash = d.select do |k,v| 
     [:name, :published_at, :body].include?(k)
    end
    stemcell_releases.push(new_hash)
  end

  return stemcell_releases.to_json

end


# if diffs between new stemcell info and existing stemcell info, then
# write the new stemcell json and run the script that updates the stemcell releases notes

old_stemcell_json = get_stemcells_json
new_stemcell_json = get_stemcells_github

if new_stemcell_json != old_stemcell_json
  put_stemcells_json(new_stemcell_json)
  contentcontent = build_new_rn(new_stemcell_json)
  update_rn(contentcontent)
end
