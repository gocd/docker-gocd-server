require 'erb'

def get_var(name)
  if ENV[name].to_s.strip.empty?
    raise "environment #{name} not specified!"
  else
    ENV[name]
  end
end

gocd_version = get_var('GOCD_VERSION')
download_url = get_var('GOCD_SERVER_DOWNLOAD_URL')

task :create_dockerfile do
  template = File.read('Dockerfile.erb')
  renderer = ERB.new(template, nil, '-')
  File.open('Dockerfile', 'w') do |f|
    f.puts(renderer.result(binding))
  end
end

task :build_docker_image do
  sh("docker build . -t gocd-server:v#{gocd_version}")
end

task :commit_dockerfile do
  sh("git add Dockerfile")
  sh("git commit -m 'Update Dockerfile with GoCD Version #{gocd_version}' --author 'GoCD CI User <godev+gocd-ci-user@thoughtworks.com>'")
end

task :create_tag do
  sh("git tag 'v#{gocd_version}'")
end

task :git_push do
  maybe_credentials = "#{ENV['GIT_USER']}:#{ENV['GIT_PASSWORD']}@" if ENV['GIT_USER'] && ENV['GIT_PASSWORD']
  repo_url = "https://#{maybe_credentials}github.com/#{ENV['REPO_OWNER'] || 'gocd'}/docker-gocd-server"
  sh(%Q{git remote add upstream "#{repo_url}"})
  sh("git push upstream master")
  sh("git push upstream --tags")
end

desc "Publish to dockerhub"
task :publish => [:create_dockerfile, :commit_dockerfile, :create_tag, :git_push]

desc "Build an image locally"
task :build_image => [:create_dockerfile, :build_docker_image]
