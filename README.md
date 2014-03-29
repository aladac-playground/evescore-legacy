EVEScore - EVE Online PvE Scoreboard
========
EVEScore is a Player vs Environment scoreboard for the MMO Game EVE Online.
It relies on [EVE API Wallet Journal method](https://wiki.eveonline.com/en/wiki/EVE_API_Character_Wallet_Journal), and keeps track of *mission and incursion rewards, bounties, NPC kills*
It is an extension of the idea originally spawned as http://www.evescore.com

Work in progress
========
EVEScore is still work in progress. You are welcome to help if you want. You are welcome to fork it and modify it.

If something doesn't work for you. Report an issue [here](https://github.com/quanchi/evescore/issues)

PLEASE DO NOT REPORT ISSUES ASKING HOW TO INSTALL ruby, rails 

Setup
========
Minimal setup requires having `ruby` and `bundler`.
If you are using Ubuntu or Mac OS and have the default system Ruby it will probably be outdated (1.8.6, 1.8.7).

```bash
# uname -a
Darwin szarlotka 12.5.0 Darwin Kernel Version 12.5.0: Sun Sep 29 13:33:47 PDT 2013; root:xnu-2050.48.12~1/RELEASE_X86_64 x86_64
# ruby -v
ruby 1.8.7 (2012-02-08 patchlevel 358) [universal-darwin12.0]
```

If you are planning to install Ruby I highly recommend using [RVM](http://rvm.io/).


```bash
# git clone https://github.com/quanchi/evescore.git
# cd evescore
# bundle
# rake db:setup
# foreman start

```
All of the ubove under the assumption that you have `ruby` and the `bundler` gem installed.

It would be nice to modify/create the `.env` file which is used by `foreman` which contains the credentials for the email account used for registration confirmation messages, password recovery etc.


Preview
========
The BETA version is running on http://beta.evescore.com


