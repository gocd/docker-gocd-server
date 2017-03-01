require 'erb'

(gocd_version = ENV['GOCD_VERSION']) || raise('GOCD_VERSION not specified')
(download_url = ENV['DOWNLOAD_URL']) || raise('DOWNLOAD_URL not specified')

task :create_dockerfile do
  template = File.read('Dockerfile.erb')
  renderer = ERB.new(template)
  File.open('Dockerfile', 'w') do |f|
    f.puts(renderer.result(binding))
  end
end

task :build_docker_image do
  sh('docker build . -t gocd-server')
end

task :commit_dockerfile do
  sh("git add Dockerfile")
  sh("git commit -m 'Update Dockerfile with GoCD Version #{gocd_version}'")
end

task :create_tag do
  sh("git tag 'v#{gocd_version}'")
end

task :git_push do
  sh("git push --all")
end

task "Publish to dockerhub"
task :publish => [:create_dockerfile, :commit_dockerfile, :create_tag, :git_push]

task "Build an image locally"
task :build_image => [:create_dockerfile, :build_docker_image]
