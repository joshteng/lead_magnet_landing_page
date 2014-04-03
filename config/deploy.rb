# STEP 1: mina setup
# STEP 2: mina create:db
# STEP 3: mina deploy
# STEP 4: mina start:all


require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support


set :domain, 'lead_magnet.growthautomator.com'
set :deploy_to, '/home/deploy/apps' #should already exists
set :repository, 'git@github.com:joshteng/lead_magnet_landing_page.git'
set :branch, 'deploy-with-mina'
set :app_name, 'lead_magnet'
set :test_log, "log/capistrano.test.log"

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

desc "Populate database.yml"
task :'setup:db:database_yml' => :environment do
  puts "Enter a user for the new database"
  db_username = STDIN.gets.chomp
  puts "Enter a password for the new database"
  db_pass = STDIN.gets.chomp
  # Virtual Host configuration file
  database_yml =
    "production:\n  adapter: postgresql\n  encoding: unicode \n  database: #{app_name}_production\n  username: #{db_username}\n  password: #{db_pass}\n  host: localhost\n  pool: 5\n"

  puts database_yml
  queue! %{
    echo "-----> Populating database.yml"
    echo "#{database_yml}" > #{deploy_to}/shared/config/database.yml
    echo "-----> Done"
  }
end

desc "Populate application.yml"
task :'setup:application_yml' => :environment do
  puts "Paste how your application.yml file should be like. Type `END` and hit return once your done."
  $/ = "END"
  application_yml = STDIN.gets
  application_yml.chomp!("END")
  queue! %{
    echo "-----> Populating application.yml"
    echo "#{application_yml}" > #{deploy_to}/shared/config/application.yml
    echo "-----> Done"
  }
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  invoke :'setup:db:database_yml'
  invoke :'setup:application_yml'

  puts "---> Create your database by running `mina create:db"
end

# Create the new database based on information from database.yml
# In this application DB, user is given full access to the new DB
desc "Create new database"
task :'create:db' => :environment do
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

  puts "-----> You're now ready to deploy with `mina deploy`"
end

desc "test before deploying"
task :test do
  puts "-----> Running test"
  system "touch #{test_log}"
  unless system "bundle exec rspec spec > #{test_log} 2>&1"
    print_error "Test Failed. Fix your errors before deploying"
    exit
  else
    puts "-----> Completed test"
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :test
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
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



