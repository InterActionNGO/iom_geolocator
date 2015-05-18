set :default_stage, "staging"
set :rvm_type, :system

set :use_sudo, false

role :app, 'ubuntu@66.228.36.71'
role :web, 'ubuntu@66.228.36.71'
role :db,  'ubuntu@66.228.36.71', :primary => true

set :branch, fetch(:branch, "master")
