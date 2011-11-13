require 'capistrano/ext/multistage'
require 'bundler/capistrano'
begin
  require 'capistrano_colors'
rescue LoadError
  puts "`gem install capistrano_colors` to get output more userfriendly."
end

set :application, "medusa"
set :repository,  "git@github.com:marsz/medusa.git"

set :scm, :git

set :stages,        %w(staging production)
set :default_stage, "production"

task :tail, :roles => :app do
  run "tail -f #{release_path}/log/#{rails_env}.log"
end

namespace :deploy do
  task :all do
    tmp_clean
    scm_update
    bundle_install
    db_migrate
    cron
    httpd_restart
  end
  task :tmp_clean do
     run "cd #{release_path};rake tmp:clear RAILS_ENV=production;"
  end
  task :scm_update do
     run "cd #{release_path};git checkout db/schema.rb;git pull;"
  end
  task :bundle_install do
     run "cd #{release_path} && bundle install;"
  end
  task :db_migrate do
     run "cd #{release_path};rake db:migrate RAILS_ENV=production;"
  end
  task :cron do
    run "cd #{release_path} && whenever --update-crontab;"
  end
  task :httpd_restart do
     default_run_options[:pty] = true
     run "sudo service httpd restart;"
  end
end