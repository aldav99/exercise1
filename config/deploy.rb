# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "exercise1"
set :repo_url, "git@github.com:aldav99/exercise1.git"


# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/exercise1"

set :deploy_user, 'deployer'

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto


# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key", "config/sidekiq.yml", "config/cable.yml", "config/thinking_sphinx.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'vendor/bundle', "public/uploads", "db"
                    # 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system'


# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
     # execute :touch, release_path.join('tmp/restart.txt')
     invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
