# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"

set :application, "users"
set :repo_url, "git@github.com:neeraj33negi/users.git"

set :puma_role, "puma-app"

set :ssh_options, user: 'ubuntu'
set :rbenv_type, :user
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all

set :deploy_to, '/mnt/apps/users'

set :pty, true

append :linked_files, 'config/database.yml', 'config/secrets.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :keep_releases, 5

set :puma_min_threads, 1
set :puma_max_threads, 2

require_relative "./deploy/secret_tasks"
require_relative "./deploy/puma_tasks"

