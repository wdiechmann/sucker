# README

Sucker [ed: for Rails] is a test application to verify whether 
NGINX as a reverse proxy, and Puma as the application server,
are able to deliver on the wss promises of Action Cable.

Spoiler alert: It does :)

Hence right now this project serves as a test of my next issue: when posting messages, I am only able to attach one file, and not anything in excess of 8KB.

Update 13th June 2019:

So, finally - I cracked it! 

The giveaways were 

- /var/lib/nginx/tmp/client_body/0000000004" failed (13: Permission denied) in /var/log/nginx/sucker.error.log
- the 'dot' after the file permissions!

I knew I had disabled SELinux already but little did I know that files are protected even with SELinux disabled (makes a lot of sense)

So I had to do this

```
# yum install attr
# find /var/lib/nginx -exec sudo setfattr -h -x security.selinux {} \;
# cd /var/lib/nginx
# chown -R oxenserver.nginx tmp
# chmod 766 -R tmp
# service nginx reload
```
(on my CentOS box with the /etc/nginx.conf user set to oxenserver)

## Contents of Sucker

Sucker does not really offer much in terms of content - a single 
MessagesController is all there is.

But the project demonstrates what goes into a deployment ready
application - so it's easy for you to 'add the toppings' like
your own models, controllers, etc.

## Requirements

I went with CentOS - but you obviously could pick from a wide 
palet of distributions (or even take on Windows).

<span style="color:red">My misery was forgetting all about SELinux - once I had
that squelched, all was good!</span> (but getting websockets can be a 
challenge I hear from people I contacted during my own purgatory)

Sucker (well it's actually ActionCable) requires Redis, and 
my choice of RDBMS - MySQL/MariaDB. The RDBMS part is easy to change,
but substituting Redis for something (fancier?) might challenge you.

When this is all in place you have a few configurations to tick off;

(Well, first you should clone this repo - but I guess that's a given)

`git clone https://github.com/wdiechmann/sucker.git`

## Environment variables

I've put most variables into ENV - or at least as many as I figured
would give you a head start - so go on and `touch .env.production` in
the project root folder.

In there, you will put this:

    # it will go into config/sucker.nginx.conf
    # and be the 'web-server' to hit - eg. sucker.alco.dk
    FQDN=host.sld.tld

    # got your own repo?
    REPO_URL=git@github.com/wdiechmann/sucker.git

    # the user to use for accessing the hosts
    # once you will deploy
    # use more than one only if you feel industrious
    DEPLOY_ROLE_APP=your_deploy_user@ruby2019.alco.dk
    DEPLOY_ROLE_WEB=your_deploy_user@ruby2019.alco.dk
    DEPLOY_ROLE_DB=your_deploy_user@ruby2019.alco.dk

    # settings for the MySQL/MariaDB RDBMS
    SQL_DATABASE=sucker_production
    SQL_USER=mysql
    SQL_PASSWORD=your_very_private_secret_password
    SQL_HOST=10.0.0.23

    # action cable settings
    # the first two should be 'wss://' + the FQDN + '/cable'
    WS_SERVER_URL=wss://sucker.alco.dk/cable
    ACTION_CABLE_URL=wss://sucker.alco.dk/cable
    ACTION_CABLE_ORIGIN=https://sucker.alco.dk
    ACTION_CABLE_MOUNT=/cable

    REDIS_URL=redis://localhost:6379/1
    REDIS_CHANNEL_PREFIX=sucker_production

## 4 bundles, 1 symlink, a reload, a start, and an open

With most of the setting up set in it is time to set down get set and set out :)

* bundle install

* bundle exec cap production setup:upload_yml

* bundle exec cap production deploy:check

* bundle exec cap production deploy

* (change to the deployment machine - the webserver) 

* cd /etc/nginx/sites-enabled && ln -s /$DEPLOY_TO/current/config/sucker.nginx.conf sucker

* sudo service nginx reload

* (change back to your local machine) 

* bundle exec cap puma:restart

* open http://sucker.some-sld.tld/messages
