[<img src='cloud-auditor-logo.png' width='450' height='200'>](https://github.com/yangsec888/cloud-auditor)
=====================

- [Cloud Auditor](#cloud-auditor)
- [Technology Stacks](#technology-stacks)
- [Installation](#installation)
  - [Docker Build](#docker-build)
  - [Linux Deployment](#linux-deployment)
  - [Test Project](#test-project)
- [To Dos](#to-dos)

---

## Cloud Auditor
In a nutshell, this custom application is built to help automate cloud security audit with scale.

## Technology Stacks
Build in Ruby on Rails 5.2, the project aims to fast-prototype and integration development. The project depends on open source projects [Prowler](https://github.com/toniblyx/prowler), [ScoutSuite](https://github.com/nccgroup/ScoutSuite), and others as below, in order to work properly:

* [Ruby on Rails 5.x](https://rubyonrails.org/) - A web-application framework that includes everything.
* [Devise](https://github.com/plataformatec/devise/wiki) - Rails authentication and user session management solution.
* [Twitter Bootstrap](https://getbootstrap.com/) - A great UI boilerplate for modern web apps.
* [jQuery](https://jquery.com/) - Great JavaScript library for JavaScript integration.
* [CodeMirror](https://codemirror.net/) - CodeMirror is a versatile text editor implemented in JavaScript.
* [jstree](https://www.jstree.com/) -  jsTree is a JavaScript based tree UI implementation.
* [sqlite3](https://www.sqlite.org/) - SQLite is a small and fast SQL database engine.

## Installation

The fastest way to get it up and running is via docker as below. Alternatively, you can also deploy the code into a virtual machine; setup the runtime environment; then run the application from there.

### Docker Build
The project is built with Docker support. If you have [docker engine](https://docs.docker.com/install/) ready, you can have the app build and run in no time. Once you have clone the project, just run it:
```sh
$ git clone https://github.com/yangsec888/cloud-auditor.git
$ cd cloud-auditor
$ docker-compose up
```
In your browser address bar, change it to 'http://localhost/' it should be up and running.

### Linux Deployment
You can also deploy the application into a Linux distribution such as Ubuntu 18.04 natively, but following the [deployment guide](linux_deployment.md).

### Test Project
TBD


## To Dos
 - Expand audit coverage to other cloud such as Microsoft Azure
 - Write specific feature enhancements
 - Write defensible code :)
 - Write (integration, deployment) tests
 - Enhance performance (squeeze the next bit out of cpu / network IO )
 - Fix bugs!
