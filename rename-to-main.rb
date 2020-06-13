#!/usr/local/bin/ruby -w
require 'octokit'
require 'yaml'
require 'set'
require 'json'

unless File.exist?('config.yaml')
  raise LoadError("File config.yaml does not exist")
end

config = YAML.load_file('config.yaml')
owner = config.has_key?('owner') ? config['owner'] : config['login']

client = Octokit::Client.new(:login => config['login'], :password => config['access_token'])
client.login

all_repos = client.repositories(owner)
last_response = client.last_response

def rename_master_to_main(owner, client, repositories)
  repositories.each do |repo|

    repo_name = "#{owner}/#{repo.name}"

    if !repo.archived && !repo.fork && repo.default_branch == "master"

      puts "Performing rename for #{repo_name}"

      `mkdir -p work/#{repo_name}`
      `git clone #{repo.clone_url} work/#{owner}/#{repo.name}`
      `git --git-dir work/#{owner}/#{repo.name}/.git branch -m master main`
      `git --git-dir work/#{owner}/#{repo.name}/.git push -u origin main`
      client.edit_repository(repo_name, {:default_branch => "main"})
      `git --git-dir work/#{owner}/#{repo.name}/.git push origin --delete master`
    else
      puts "Skipping #{repo_name}"
    end
  end
end

while last_response.rels[:next] do
  all_repos.concat last_response.rels[:next].get.data
  last_response = last_response.rels[:next].get
end

rename_master_to_main(owner, client, all_repos)
