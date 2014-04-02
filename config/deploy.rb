require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support


set :domain, '128.199.205.103'
set :deploy_to, '/home/deploy/apps'
set :repository, 'git@github.com:joshteng/lead_magnet_landing_page.git'
set :branch, 'deploy-with-mina'
set :app_name, 'lead_magnet'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/application.yml', 'log']

set :user, 'deploy'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

RYAML = <<-BASH
function ryaml {
  ruby -ryaml -e 'puts ARGV[1..-1].inject(YAML.load(File.read(ARGV[0]))) {|acc, key| acc[key] }' "$@"
};
BASH

task :environment do
  invoke :'rbenv:load'
end

task :restart do
  queue 'sudo service nginx restart'
  queue 'sudo service postgresql restart'
  queue "sudo service unicorn_#{app_name} restart"
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/application.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/application.yml'."]

  queue! %[echo "-----> After updating 'database.yml', run `mina setup:db` if this is the first time setting up"]
end

# Create the new database based on information from database.yml
# In this application DB, user is given full access to the new DB
desc "Create new database"
task :'setup:db' => :environment do
  queue! %{
    echo "-----> Import RYAML function"
    #{RYAML}
    echo "-----> Read database.yml"
    USERNAME=$(ryaml #{deploy_to!}/#{shared_path!}/config/database.yml #{rails_env} username)
    PASSWORD=$(ryaml #{deploy_to!}/#{shared_path!}/config/database.yml #{rails_env} password)
    DATABASE=$(ryaml #{deploy_to!}/#{shared_path!}/config/database.yml #{rails_env} database)
    echo "-----> Create SQL query"
    Q1="create database $DATABASE owner $USERNAME;"
    SQL="${Q1}"
    echo "-----> Execute SQL query to create DB and user"
    echo "-----> Enter Postgres password on prompt below"
    #{echo_cmd %[sudo -u postgres psql -c "$SQL"]}
    echo "-----> Done"
  }
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    # invoke :'symlink:all_config'

    # to :launch do
    #   queue "touch #{deploy_to}/tmp/restart.txt"
    # end
  end
end



task :'create:directories' do
  queue! %[rm -rf /tmp/unicorn.lead_magnet.sock]
  queue! %[rm -rf /tmp/pids]
  queue! %[mkdir /tmp/pids]
  queue! %[rm -rf "#{deploy_to}/current/tmp"]
  queue! %[mkdir "#{deploy_to}/current/tmp"]
  queue! %[rm -rf "#{deploy_to}/current/tmp/pids"]
  queue! %[mkdir "#{deploy_to}/current/tmp/pids"]
end

namespace :symlink do
  task :nginx => :environment do
    queue! %[sudo -u root rm -f /etc/nginx/sites-enabled/default]
    queue! %[sudo rm -f "/etc/nginx/sites-enabled/#{app_name}"]
    queue! %[sudo ln -s "#{deploy_to}/current/config/nginx.conf" "/etc/nginx/sites-enabled/#{app_name}"]
  end

  task :unicorn_init do
    queue! %[chmod +x "#{deploy_to}/current/config/unicorn_init.sh"]
    queue! %[sudo rm -f "/etc/init.d/unicorn_#{app_name}"]
    queue! %[sudo ln -s "#{deploy_to}/current/config/unicorn_init.sh" "/etc/init.d/unicorn_#{app_name}"]
  end

  task :all_config do
    invoke :'symlink:nginx'
    invoke :'symlink:unicorn_init'
  end
end

namespace :start do
  task :nginx => :environment do
    queue! %[sudo service nginx start]
  end

  task :unicorn => :environment do
    queue! %[service "unicorn_#{app_name}" start]
  end

  task :all => :environment do
    invoke :'create:directories'
    invoke :'symlink:all_config'
    invoke :'start:nginx'
    invoke :'start:unicorn'
  end
end



