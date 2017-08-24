#!/bin/env ruby
require 'gitlab'
require 'pry-byebug'
binding.pry
p=Gitlab.search_projects('coredns').first                                                                                                                                                                                  
Gitlab.edit_project(p.id,{name:p.name,ci_config_path:'https://gitlab.ii.nz/cncf/cross-cloud/raw/ci-centralized-config/ci/coredns/coredns/GITREF.gitlab-ci.yml'})
