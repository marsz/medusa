$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"

require 'capistrano/ext/multistage'
require "whenever/capistrano"
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

task :tail_log, :roles => :app do
  run "tail -n 100 -f #{current_path}/log/#{rails_env}.log"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :symlink_shared, :roles => [:app] do
    config_files = [:database, :builder, :fog, :exceptional, :newrelic]
    symlink_hash = {}
    config_files.each do |fname|
      symlink_hash["#{shared_path}/config/#{fname}.yml"] = "#{release_path}/config/#{fname}.yml"
    end
    symlink_hash.each do |source, target|
      run "ln -s #{source} #{target}"
    end
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

before "deploy:assets:precompile", "deploy:symlink_shared"
before "deploy:migrate", "deploy:symlink_shared"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:symlink_shared"
after "deploy:migrations", "deploy:cleanup"