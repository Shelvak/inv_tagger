set :application, 'inv_tagger'
set :user, 'deployer'
set :repo_url, 'https://github.com/Shelvak/inv_tagger.git'

set :scm, :git
set :deploy_to, '/var/rails/inv_tagger'
set :deploy_via, :remote_cache

set :format, :pretty
set :log_level, :info

set :linked_files, %w{config/app_config.yml}
set :linked_dirs, %w{log private}

set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Update crontab with whenever'
  after :finishing, 'deploy:cleanup' do
    on roles(:all) do
      within release_path do
        execute :rake, 'tmp:clear'
        execute :mkdir, 'tmp/to_print'
      end
    end
  end
end
