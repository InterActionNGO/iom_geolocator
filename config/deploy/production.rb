require 'capistrano/rvm'
set :rvm_ruby_version, '2.2.1'
set :default_stage, "production"

role :app, 'ubuntu@23.92.20.76'
role :web, 'ubuntu@23.92.20.76'
role :db,  'ubuntu@23.92.20.76', :primary => true

set :branch, "master"
