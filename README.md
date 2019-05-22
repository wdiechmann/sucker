# README

Sucker [ed: for Rails] is a test application to verify whether 
NGINX as a reverse proxy, and Puma as the application server,
are able to deliver on the wss promise.

Things to do once you've cloned this repo:

* change repo_url in config/deploy.rb

* change some-sld.tld in config/sucker.nginx.conf

* change all roles in config/deploy/production.rb

* change production database user, host, and password in config/database.yml

* bundle exec cap production deploy

* (deployment machine) cd /etc/nginx/sites-enabled && ln -s /$DEPLOY_TO/current/config/sucker.nginx.conf sucker

* sudo service nginx reload

* (local machine) bundle exec cap puma:start

* http://sucker.some-sld.tld/messages

Look out for errors in the Chrome/Firefox/et al. DevTools 