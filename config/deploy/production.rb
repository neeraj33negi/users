set :rails_env, 'production'
set :branch, 'main'

server 'ec2-13-201-228-26.ap-south-1.compute.amazonaws.com', user: 'ubuntu', roles: %w[app db web assets puma-app], name: 'local'
set :puma_workers, 2
