role :app, ["#{ENV['DEPLOY_ROLE_APP']}"]
role :web, ["#{ENV['DEPLOY_ROLE_WEB']}"]
role :db,  ["#{ENV['DEPLOY_ROLE_DB']}"]
