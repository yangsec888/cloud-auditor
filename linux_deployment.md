[<img src='cloud-auditor-logo.png' width='450' height='200'>](https://github.com/yangsec888/cloud-auditor)
=====================

- [Service Account Setup](#service-account-setup)
- [Prowler Installation](#prowler-installation)
- [ScoutSuite Installation](#scoutsuite-installation)
- [RoR Installation](#ror-installation)
- [Running the cloud-auditor App](#running-the-cloud-auditor-app)
---
# Linux Deployment Example
Example setup the runtime environment in Ubuntu 18.0.4 Linux distribution

Cloud Auditor app requires Ruby on Raills (RoR) 2.5.x, MariaDB v10.4.x database, Nginx 1.x web server, the NCC ScoutSuite software, Prowler software, in order to run properly.

## Service Account Setup
To start, we'll create a service account "deploy" for the Rails app running environment. We'll add the service account to the special group 'wheel', which is allowed to have 'sudo' access.
```sh
# adduser deploy
# addgroup wheel
# usermod -aG wheel deploy
```

## Prowler Installation
TBD

## ScoutSuite Installation
TBD

## RoR Installation
RoR is built on top of Ruby programming language. Before installation of RoR, you need to setup the right Ruby environment. This project code base was developed under Ruby 2.5.1. But it should run in latest stable Ruby environment, with some small tweaks. Without going into the Ruby / RoR ecosystem complexity, let's stick with Ruby 2.5.1 for simplicity purpose.

First of all, you would need a Ruby package manager. Either Rbenv or RVM shoudl work. I chosed RVM in my development environment. Refer to [RVM Website](https://rvm.io/) for more information.
```sh
$ gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
$ \curl -sSL https://get.rvm.io | bash -s stable
```

Secondarily, once RVM is successfully installed, you would need to download the right Ruby distribution. In my development environment, here is what I do:
```sh
$ rvm install 2.5.1
```

## Running the cloud-auditor App
Thirdly, once Ruby environment is setup, you can proceed to download the project and install the RoR runtime:
```sh
$ git clone https://github.com/yangsec888/cloud-auditor.git
$ cd cloud-auditor
$ bundle install
$ rake db:create
$ rake db:migration
$ rails server
```

Pointing your browser to http://://localhost:3000/ You should be able to see cloud-auditor logon page.
