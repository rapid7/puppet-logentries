# Logentries for Puppet

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
    * [Why Logentries](#why-logentries)
3. [Setup](#setup)
    * [What Logentries does](#what-logentries-does)
    * [Setup requirements](#setup-requirements)
    * [Install](#install)
4. [Usage](#usage)
    * [Install the agent](#install-the-agent)
    * [Simply follow a logfile](#follow-a-logfile)
    * [Add a logfile to a logset or destination](#Add-a-logfile-to-a-logset-or-destination)
6. [Limitations](#limitations)
    * [Known Issues](#known-issues)
7. [Development](#development)

## Overview

This is a [Puppet](http://docs.puppetlabs.com/) module for easy installation
and configuration of the [logentries](|https://logentries.com)
[linux agent](https://logentries.com/doc/linux-agent/).

## Module Description

This is the official module for working with Logentries in puppet.

With this module, you are currently able to
 * automatically add the logentries repos and GPG keys for
   * RHEL 7/CentOS7
   * Ubuntu 14.04 (trusty)
   * Debian 8 (Jessie)
   * other versions of those distributions may work but are currently not tested.
 * configure the logentries agent
 * follow logs via either local config or server side config, host based or via tokens

### Why Logentries

Logentries is a real-time log management and analytics service that makes
it easy to collect logs from any environment for search, monitoring and analysis.

## Setup

### What Logentries Does

By using this module, you will deploy and run an [open source log collecting client daemon](https://github.com/logentries/le)
(agent) implemented in python.

### Setup Requirements

For automatically managing package repos, this module requires
 * Debian/Ubuntu: [apt](https://forge.puppetlabs.com/puppetlabs/apt) with pluginsync=true
 * lsb_release

### Install

Install this module by issuing `puppet module install logentries` or by
downloading the latest version and unpacking it in your modules folder.

## Usage

Configure the logentries class with your account key - if you include this
this in any boilerplate class, you should make sure all platforms using it
are supported.

The bare minimum configuration would include only the account key:

~~~puppet
class {'logentries':
  # Get this key by executing le register manually on a test host
  # and extract it from /etc/le/config or by going to "account -> 
  # profile -> account key" in the web interface
  account_key => "nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn",
}
~~~

The module knows of a few more useful configuration parameters:

~~~puppet
class {'logentries':
  account_key => "nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn",

  # Specify the host specific agent key - useful if 
  # you need to re-setup or for whatever other reason
  # want to re-use an already registered host
  agent_key => "nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn",
  
  # Specify an alternate datahub
  datahub => "datahub.myorganization.com",
  
  # Do not create local follow configurations, but use
  # server-side configuration.
  use_server_config => true,
  
  # If you prefer to provide the logentries and logentries-daemon
  # packages via other means (e.g. your own local repo) you can
  # prevent this module from automatically adding the external
  # logentries repos.
  manage_repos => false, 
}
~~~


### Install the agent

~~~puppet
# Automatically included by logentries::agent::follow directives
include logentries::agent
~~~

### Follow a logfile

Stream the content of a logfile to logentries.

~~~puppet
# NB: This is just an example. There are significantly better ways to 
# integrate logentries with syslog than this
logentries::agent::follow {"/var/log/messages": }
~~~

### Add a logfile to a logset or destination

This would be useful if you want to combinine log sources
from similar logfiles across many hosts into one log file.

~~~puppet
# NB: This is just an example. There are significantly better ways to 
# integrate logentries with syslog than this
logentries::agent::follow {"all www server messages":
  path => "/var/log/messages",
 
  # Alternatively, specify your own destination. Only the destination
  # OR the token parameter can be used.
  destination = "www-servers/messages",

  # Create this token first in the web interface. Not
  # compatible with server-side configs.
  # token => "nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn",
}
~~~

## Limitations

1. Works on Debian, Ubuntu and RHEL/CentOS only.
2. If /etc/le/config already exists, it won't be updated unless deleted first

### Known Issues

1. Adds the RPM key via URL
2. After a class configuration change, /etc/le/config has to be manually deleted to trigger its recreation
3. To remove follow configurations, local or server side config has to be manually deleted.
4. No sensible syslog support
5. No datahub class
6. No filter support
