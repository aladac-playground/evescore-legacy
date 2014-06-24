[![Build Status](https://travis-ci.org/aladac/evescore.svg?branch=master)](https://travis-ci.org/aladac/evescore)

### EVEScore - EVE Online PvE Scoreboard
EVEScore is a Player vs Environment scoreboard for the MMO Game EVE Online.
It relies on [EVE API Wallet Journal method](https://wiki.eveonline.com/en/wiki/EVE_API_Character_Wallet_Journal), and keeps track of *mission and incursion rewards, bounties, NPC kills*
It is an extension of the idea originally spawned as http://www.evescore.com

---

### Work in progress
EVEScore is still work in progress. 

You are welcome to help if you want. 

You are welcome to fork it and modify it.

If something doesn't work for you. Report an issue [here](https://github.com/quanchi/evescore/issues)

PLEASE DO NOT REPORT ISSUES ASKING HOW TO INSTALL ruby, rails 

---

### Setup
Minimal setup requires having `ruby` and `bundler`. EVEScore uses a *MySQL ActiveRecord* adapter.
It is probably possible to use a different DB driver, but some parts rely on MySQL specific syntax:

*Example*

```ruby
query = "LOAD DATA LOCAL INFILE '#{path}' into table rats ( id, name, rat_type, description );"
ActiveRecord::Migration.execute query
```


If you are using Ubuntu or Mac OS and have the default system Ruby it will probably be outdated (1.8.6, 1.8.7).

```bash
uname -a
Darwin szarlotka 12.5.0 Darwin Kernel Version 12.5.0: Sun Sep 29 13:33:47 PDT 2013; root:xnu-2050.48.12~1/RELEASE_X86_64 x86_64

ruby -v
ruby 1.8.7 (2012-02-08 patchlevel 358) [universal-darwin12.0]
```

If you are planning on installing Ruby I highly recommend using [RVM](http://rvm.io/).

*Install Tasks*

##### Clone the source and bundle gems
```bash
git clone https://github.com/quanchi/evescore.git
cd evescore
bundle
```
##### Create the `.env` file
...which is used by `foreman` and contains the configuration environment variables (credentials for the email account used for registration confirmation messages, password recovery etc. )

`.env.example` shows how the file should look.

##### Create `config/database.yml`
You can use `config/database.yml.example` as a template

##### Seed the database and run the Rails App

```
RAILS_ENV=production rake db:setup
foreman start
```

##### Consider using nginx or Apache as a proxy
How? Why? Just google "Rails *WEB_SERVER_PLACEHOLDER* and unicorn tutorial *YOUR_FAVOURITE_LINUX_DISTRO_PLACEHOLDER*"

*Example*

```
rails nginx and unicorn tutorial ubuntu 12.04
```


---

### Preview
The BETA version is running on http://beta.evescore.com

---

### Legal
All [EVE Online](http://www.eveonline.com) related content and materials used in this project are subject to the below copyright notice

##### EVE Online copyright notice

[EVE Online](http://www.eveonline.com) and the EVE logo are the registered trademarks of CCP hf. All rights are reserved worldwide. All other trademarks are the property of their respective owners. [EVE Online](http://www.eveonline.com), the EVE logo, EVE and all associated logos and designs are the intellectual property of CCP hf. All artwork, screenshots, characters, vehicles, storylines, world facts or other recognizable features of the intellectual property relating to these trademarks are likewise the intellectual property of CCP hf. CCP hf. has granted permission to EVE Score to use [EVE Online](http://www.eveonline.com) and all associated logos and designs for promotional and information purposes on its website but does not endorse, and is not in any way affiliated with, EVE Score. CCP is in no way responsible for the content on or functioning of this website, nor can it be liable for any damage arising from the use of this website.