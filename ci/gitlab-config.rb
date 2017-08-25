#!/bin/env ruby
require 'gitlab'
require 'pry-byebug'

@ci_config_root='https://gitlab.ii.nz/cncf/cross-cloud/raw/ci-centralized-config/ci'

@top_group_name='cncf-ci'

@top_group = Gitlab.group_search(@top_group_name).find do |group|
  # look for a group without a parent id that matches our path
  ! group.to_hash['parent_id'] && group.to_hash['path']==@top_group_name
end

@top_group ||= Gitlab.create_group(top_group_name,
                              top_group_name,
                              {
                                description: 'Contain our CI',
                                visibility: 'public',
                                request_access_enable: true
                              })
#p=Gitlab.search_projects('coredns').first
#Gitlab.edit_project(p.id,{name:p.name,ci_config_path:'https://gitlab.ii.nz/cncf/cross-cloud/raw/ci-centralized-config/ci/coredns/coredns/GITREF.gitlab-ci.yml'})
@runner = Gitlab.runners.find{|x| x.to_hash['description']='runner.ii.nz'}

project_urls = [
  'https://github.com/kubernetes/kubernetes.git',
  'https://github.com/coredns/coredns.git',
  'https://github.com/prometheus/prometheus.git',
  'https://github.com/prometheus/node_exporter.git',
  'https://github.com/prometheus/alertmanager.git'
]

project_urls.each_with_index do |url, i|
  group_path, project_path = url.split('/')[-2..-1]
  project_path.gsub!(".git", "")

  group = Gitlab.group_search(group_path).find do |group|
    group.to_hash['parent_id'] == @top_group.id &&
      group.to_hash['path'] == group_path
  end
  unless group
    group = Gitlab.create_group(
      group_path,
      group_path,
      {
        visibility: 'public',
        parent_id: @top_group.id
        # Would be great to set gravatar urls automatically
      })
  end

  params = {
    import_url: url,
    namespace_id: group.id,
    name: project_path,
    ci_config_path: "#{@ci_config_root}/#{group_path}/#{project_path}/GITREF.gitlab-ci.yml",
    description: "Mirroring from #{url}",
    visibility: "public",
    jobs_enabled: true,
    public_jobs: true,
    container_registry_enabled: true,
    wiki_enabled: false,
    issues_enabled: false,
    snippets_enabled: false,
    merge_requests_enabled: false,
    request_access_enabled: true
    #avatar: image_file
    #tag_list: []
  }

  project = Gitlab.group_projects(group.id,project_path).find do |project|
    project.to_hash['path']==project_path
  end
  if project
    # it already exists, just update it
    Gitlab.edit_project(project.id,params)
  else
    project = Gitlab.create_project(project_path,params)
  end
  binding.pry
  Gitlab.project_enable_runner(project.id,@runner.id)
end
