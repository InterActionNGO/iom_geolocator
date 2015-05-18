# require 'config/boot'
require "bundler/capistrano"

set :use_sudo, false
set :stages, %w(staging production smbtc)

default_run_options[:pty] = true

set :application, 'ngo-geo'

set :scm, :git
set :linked_files, %w{.env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :scm_user, 'ubuntu'
set :repository, "git@github.com:Vizzuality/iom_geolocator.git"
ssh_options[:forward_agent] = true
set :keep_releases, 5

# set :linode_staging_old, '178.79.131.104'
# set :linode_production_old, '173.255.238.86'
set :linode_production, '23.92.20.76'
set :linode_staging, '66.228.36.71'
set :user,  'ubuntu'

set :deploy_to, "/home/ubuntu/www/#{application}"

after  "deploy:update_code", :geo, :set_staging_flag
after "deploy:update", "deploy:cleanup"

desc "Restart Application"
deploy.task :restart, :roles => [:app] do
  run "touch #{current_path}/tmp/restart.txt"
  run "#{sudo} /etc/init.d/memcached force-reload"
end

desc "Geo"
task :geo, :roles => [:app] do
  run <<-CMD
    export RAILS_ENV=production &&
    cd #{release_path} &&
    bundle exec rake db:geo
  CMD
end
