set :use_sudo, false
set :stages, %w(staging production smbtc)

set :application, 'ngo-geo'

set :scm, :git
set :linked_files, %w{.env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :scm_user, 'ubuntu'
set :repo_url, "git@github.com:Vizzuality/iom_geolocator.git"
set :keep_releases, 5

set :user,  'ubuntu'

set :deploy_to, "/home/ubuntu/www/ngo-geo"
set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)

# clear the previous precompile task
Rake::Task["deploy:assets:precompile"].clear_actions
class PrecompileRequired < StandardError; end

namespace :deploy do
  namespace :assets do
    desc "Precompile assets"
    task :precompile do
      on roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            begin
              # find the most recent release
              latest_release = capture(:ls, '-xr', releases_path).split[1]

              # precompile if this is the first deploy
              raise PrecompileRequired unless latest_release

              latest_release_path = releases_path.join(latest_release)

              # precompile if the previous deploy failed to finish precompiling
              execute(:ls, latest_release_path.join('assets_manifest_backup')) rescue raise(PrecompileRequired)

              fetch(:assets_dependencies).each do |dep|
                # execute raises if there is a diff
                execute(:diff, '-Naur', release_path.join(dep), latest_release_path.join(dep)) rescue raise(PrecompileRequired)
              end

              info("Skipping asset precompile, no asset diff found")

              # copy over all of the assets from the last release
              execute(:cp, '-r', latest_release_path.join('public', fetch(:assets_prefix)), release_path.join('public', fetch(:assets_prefix)))
            rescue PrecompileRequired
              execute(:rake, "assets:precompile")
            end
          end
        end
      end
    end
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        # Your restart mechanism here, for example:
         execute :touch, release_path.join('tmp/restart.txt')
      end
    end
  end

  #desc 'Installing libraries'
  #after :publishing, :libraries do
  #  on roles(:app), in: :sequence, wait: 5 do
  #    execute "cd #{current_path} && bundle install --without=test"
      #execute "cd #{current_path} && npm install -d -s"
      #execute "cd #{current_path} && bower install"
  #  end
  #end

  #desc 'Grunt build'
  #after :libraries, :grunt do
  #  on roles(:app), in: :sequence, wait: 5 do
  #    execute "cd #{current_path} && grunt build"
  #  end
  #end

  desc 'reload the database with seed data'
  after :publishing, :seed do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        if fetch(:rails_env) == "production"
          execute :rake, 'db:migrate RAILS_ENV=production'
          execute :rake, 'db:geo RAILS_ENV=production'
        else
          execute :rake, 'db:migrate RAILS_ENV=staging'
          execute :rake, 'db:geo RAILS_ENV=staging'
        end
      end
    end
  end

  desc 'Restart application'
  after :seed, :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'memcached:flush RAILS_ENV=production'
      end
    end
  end

  after :failed, :rollback

end