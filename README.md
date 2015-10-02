# icinga2

[![Build Status](https://travis-ci.org/spjmurray/puppet-icinga2.png?branch=master)](https://travis-ci.org/spjmurray/puppet-icinga2)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with icinga](#setup)
    * [What icinga affects](#what-icinga-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with icinga](#beginning-with-icinga)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Provisions and orchestrates icinga2 monitoring.

## Module Description

Installs the various icinga2 components in a modular way that allows any
combination of icinga2 daemons, features, and web UIs.  This way you can
provision active check endpoints, satellite servers to manage a domain,
satellite servers with IDO and icingaweb2 for managed infrastructure so
individual customers/tenants can have a view onto their domain, and top
level master servers.

## Setup

### What icinga2 affects

* Managed repositories add in pins to apt preferences to force icinga2 packages
  from the stable branch and icingaweb2 components from daily snapshots as this
  is still heavily in development.
* Installs a local mysql database if the ido_mysql feature is enabled
* Installs an apache vhost for $::fqdn on port 80 if the web UI is installed
* Installs a php.ini rule to control the timezone

### Setup Requirements

* Apache needs apache::mpm_module setting to _prefork_ or _itk_ in your hiera
  configuration for it to correctly provision with mod_php

### Beginning with icinga

#### Basic server with UI

```puppet
include ::icinga2
include ::icinga2::web
include ::icinga2::features::command
include ::icinga2::features::ido_mysql
```

#### Basic master server and satellite

##### Master

```puppet
include ::icinga2
include ::icinga2::web
include ::icinga2::features::api
include ::icinga2::features::command
include ::icinga2::features::ido_mysql

icinga::endpoint { 'master.example.com':
}

icinga::zone { 'master.example.com':
  endpoints => [ 'master.example.com' ],
}
```

##### Satellite

```puppet
include ::icinga2
include ::icinga2::features::api

icinga::endpoint { 'icinga.example.com':
  host => 'icinga.example.com',
}

icinga::zone { 'icinga.example.com':
  endpoints => [ 'icinga.example.com' ],
}

icinga::endpoint { 'icinga.sub.example.com':
}

icinga::zone { 'icinga.sub.example.com':
  endpoints => [ 'icinga.sub.example.com'],
  parent    => 'icinga.example.com',
}
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Tested on Ubuntu 14.04 only.

## Development

Fork, test with 'bundle rake exec validate' and 'bundle rake exec beaker', then
raise a pull request.
