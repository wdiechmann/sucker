role :app, %w{ENV['DEPLOY_ROLE_APP']}
role :web, %w{ENV['DEPLOY_ROLE_WEB']}
role :db,  %w{ENV['DEPLOY_ROLE_DB']}
