# Cross Cloud CI New Project Setup

The goal is to call the new project's ci scripts from gitlabs ci 
configuration file

## Gitlab Yml Configuration
1. Make crosscloudci/<projectname>-configuration project -- copy an existing <projectname>-configuration project (see testproj-configuration: https://github.com/crosscloudci/testproj-configuration/blob/master/cncfci.yml which is for the testproj example: https://github.com/crosscloudci/testproj)
2. Edit .gitlab-ci.yml to include curl commands and scripts for getting build status, deploys, and tests e.g. envoy-configuration (see https://github.com/crosscloudci/testproj-configuration/blob/master/.gitlab-ci.yml)
3. Optional: write a ci proxy plugin for your ci tool and submit a pull request (see https://github.com/crosscloudci/ex_ci_proxy/blob/master/README.md)

## Gitlab Setup
### GitLab Pipeline Setup
***You need to have admin permissions to do this***

In Gitlab you need to complete the following steps.
 1. Create a new group
 2. Create a new project
 3. Set up mirroring (*steps and menu items in gitlab*)
    - Botuser needs to be in user permissions
        - Add member
        - master
    - Impersonate bot user
        - Admin
            - Search for bot, click on bot user
            - Impersonate
    - Settings
        - Repository
            - Pull from remote repository
            - Select mirror, add https repo address, select bot user
    - Project
        - Should see that the code is pulled down
    - Stop impersonating
4. Set up project variables (*steps and menu items in gitlab*)
    - Settings
        - Pipeline trigger
	  - add trigger
	  - copy token
	  - put in environment.rb
	- Pipelines 
            - Custom ci config path
                - e.g. https://raw.githubusercontent.com/crosscloudci/envoy-configuration/master/.gitlab-ci.yml
            - Add cloud variable
                - CLOUD
                  - e.g.  aws
		- ARCH
		- GEMFURY
		- TOKEN
		  - token from earlier pipeline trigger step
5. Enable runners (*steps and menu items in gitlab*)
    - Admin
        - Runners
            - Select token
                - Select envoy
6. Add to dashboard yml (*steps and menu items in gitlab*)
    - Cncf configuration
        - Integration branch
            - Add to cross-cloud.yml
            - Duplicate a project
            - Find logo image e.g. https://d33wubrfki0l68.cloudfront.net/77bb2db951dc11d54851e79e0ca09e3a02b276fa/9c0b7/img/envoy-logo.svg
                - Add to cncf artwork repo
                - Link to cross cloud artwork repo
            - Update the project names e.g. to envoy 
            - Charts are the repo that we get the helm charts from
            - Change timeout for how long your build takes
7. Review pipelines
	- Pipelines
        - manually add new to the url (***this is a workaround***)
            - e.g. https://gitlab.cidev.cncf.ci/envoy/envoy/pipelines/new
        - Select master
        - Select stable (*e.g. v1.7.0*)
        - Both should be running
## Trigger Client
1. add the new project into the enviroment.rb

## Optional CI Setup (legacy manual build -- not using ci-proxy )

1.  Clone the project

```
git clone yourprojectname
```	
```
- e.g. git clone https://github.com/envoyproxy/envoy.git
```

2.  Make a note of any ci instructions including
scripts for building and publishing images

- e.g. the .circleci/config.yml file outlines lots of shell scripts
that refer to a docker dependencies image and build image

3. Replicate the builds

- e.g. use docker to replicate a build image using the previously viewed ci 
- you probably want to pin your image
- update the script not to push 
- images will be local after build
- publish to gitlab directory

4. Create a script that builds head 

5. Create a script that builds stable

#### How to Debug
1. Add a sleep to the .gitlab-ci.yml script
2. ssh root@runner.yourgitlaburl
3. Click on compile job

#### Gitlab yml common issues
- If .gitlab-ci.yml does not refresh: 
  - Go to pipelines
  - Copy/cut the gitlab.yml and save an empty url
  - Paste the url in again and save it


