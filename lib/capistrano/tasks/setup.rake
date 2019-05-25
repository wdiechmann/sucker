namespace :setup do

  desc "Upload database.yml file."
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
      upload! StringIO.new(File.read("config/secrets.yml")), "#{shared_path}/config/secrets.yml"
      upload! StringIO.new(File.read("config/sucker.nginx.conf").gsub(/_FQDN_/,ENV['FQDN'])), "#{shared_path}/config/sucker.nginx.conf"
      # upload! StringIO.new(File.read("config/master.key")), "#{shared_path}/config/master.key"
      upload! StringIO.new(File.read(".env.#{fetch(:stage)}")), "#{shared_path}/.env"
      upload! StringIO.new(File.read(".env.#{fetch(:stage)}")), "#{shared_path}/.env.#{fetch(:stage)}"
    end
  end

  desc 'Setup database'
  task :db_setup do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:stage) || fetch(:rails_env)) do
          execute :rake, 'db:setup' # This creates the database tables AND seeds
        end
      end
    end
  end

  desc 'Reset database'
  task :db_reset do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:stage) || fetch(:rails_env)) do
          execute :rake, 'db:drop' # This creates the database tables AND seeds
          execute :rake, 'db:create' # This creates the database tables AND seeds
          execute :rake, 'db:migrate' # This creates the database tables AND seeds
          execute :rake, 'db:seed' # This creates the database tables AND seeds
        end
      end
    end
  end

  desc "Seed the database."
  task :seed_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:seed"
        end
      end
    end
  end

end
