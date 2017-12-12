# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, 'coin_gecko_crawler'
set :repo_url, 'git@gitlab:agtop-backend/coin_gecko_crawler.git'
# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env', 'config/coin_gecko_crawler_config.yml')
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/sockets'
)
#-------------------production---------------------
set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, '2.2.2'      # Defaults to: 'default'
#---------------------sandbox----------------------
#set :rbenv_type, :user
#set :rbenv_ruby, '2.2.2'
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}
#set :rbenv_roles, :all # default value
namespace :deploy do
  before :restart, :record_branch do
    on roles(:app) do
      within current_path do
        execute :echo, "#{fetch(:branch)} > BRANCH"
      end
    end
  end
desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
after :publishing, :restart
after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end