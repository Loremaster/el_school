# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
require "rvm/capistrano"
require 'bundler/capistrano'

set :rvm_ruby_string, '1.9.3-head'                                                        # This is current version of ruby which is uses by RVM. To get version print: $ rvm list 
set :rvm_type, :root                                                                      # Don't use system-wide RVM, use my user, which name is root.

set :user, "root"                                                                         # If you log into your server with a different user name than you are logged into your local machine with, you’ll need to tell Capistrano about that user name.
set :rails_env, "production"

set :application, "el_school"
set :deploy_to, "/vol/www/apps/#{application}"
set :keep_releases, 3                                                                     # Keep only 3 last releases.

set :scm, :git
set :repository,  "git://github.com/Loremaster/el_school.git"
set :branch, "master"
set :deploy_via, :remote_cache                                                            # Keep cash of repository locally and with ney deploy get only changes.
default_run_options[:pty] = true                                                          # Must be set for the password prompt from git to work.


server "188.127.224.136", :app,                                                           # This may be the same as your `Web` server.
                          :web,
                          :db, :primary => true                                           # This is where Rails migrations will run.


#namespace :passenger do
#  desc "Restart Application"
#  task :restart do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
#end
#
#after :deploy, "passenger:restart"


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

desc "Prepare system"
task :prepare_system, :roles => :app do
  run "cd #{current_path} && bundle install --without development test && bundle install --deployment"
end
  
desc "Fix permission"
task :fix_permissions, :roles => [ :app, :db, :web ] do
  run "#{try_sudo} chmod 777 -R #{current_path}/tmp"
  run "#{try_sudo} chmod 777 -R #{current_path}/log"
end

# namespace :deploy do
#   desc "Update the crontab file"
#   task :update_crontab, :roles => :db do
#     run "cd #{release_path} && whenever --update-crontab #{application}"
#   end
# end
    
after "deploy:update_code", :prepare_system
after "deploy", "deploy:cleanup"                                                          # Clean old releases after new deploy except number from :keep_releases.
after "deploy:symlink", :fix_permissions                                                  # On a side note: deploy:symlink will soon change to deploy:create_symlink, keep that in mind if this breaks after upgrading capistrano to 2.10 or higher.
# after "deploy:symlink", "deploy:update_crontab"