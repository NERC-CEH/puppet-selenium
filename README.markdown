# selenium
[![Build Status](https://travis-ci.org/NERC-CEH/puppet-selenium.svg?branch=master)](https://travis-ci.org/NERC-CEH/puppet-selenium)
## Overview

This is the selenium module. It sets up a selenium grid infrastructure with appium nodes

## Module Description

[Selenium](http://www.seleniumhq.org/) automates browsers.

The web is a very complicated place to develop in. It is very easy to end up with an application
which doesn't quite function as expected in one of your target browsers. Modern life has exacerbated
the issue as the chances are your target browsers will cover varying mobiles and tablets. 

We use this module to setup and manage a cross platform selenium grid which contains various
physical android devices, a Mac Mini (used for Safari and the iOS simulator) and a few Ubuntu 
servers (for chrome and firefox)

### What does this module actually do?

This selenium module will obtain deploy the selenium standalone server and set it up to run
as a service under the selenium user. The instance of selenium can run in either hub or node
configurations.

The module also enables instances of [Appium](http://appium.io/) to be deployed and configured
as selenium grid nodes.

It will not obtain the android sdk or java. Both of which are required for the server to run.

### Reverse Tethering

The selenium module is capable of setting up reverse tethering for your android device. In 
order for this to work your device *must be rooted*. If you do not require reverse you can 
disable it by default by setting $reverse_tether to false on the selenium class.

Reverse tethering is configured to automatically set up when a device is connected to the host
pc.

## Setup

### What selenium affects

* Creates a service which is named selenium by default
* Manages a selenium user and group. Used for running the server
* Takes ownership of USB Devices (for the selenium user)
* Configures reverse tethering of the devices
* Runs on port 4444 by default

## Usage

Create a selenium grid hub (tested on Ubuntu 14.04)

    include selenium
    selenium::server { 'hub': 
      role => 'hub'
    }

Create a selenium testing node. This configuration will require xvfb to be setup and managed outside 
of this module

    include selenium
    selenium::server { 'node':
      role     => 'node'
      headless => true
      hub_host => 'server.name.of.hub'
    }

Create a selenium server node on a mac mini

    # Create a node to test safari on
    include selenium
    selenium::server { 'node':
      role        => 'node'
      hub_host    => 'server.name.of.hub',
      capabilites => [{browserName => 'safari', maxInstances => 5}]
    }

    # Set up appium to test against with the iOS simulator
    include selenium::appium # Manage and install appium
    selenium::appium::server { 'appium-for-ios-sim':
       port => 4723
    }

Manage an android device such that it reverse tethers on connection (Ubuntu only)
    
    include selenium::udev
    selenium::device { 'GoogleNexus5' :
      vendor        => '18d1',
      serial_number => 'S31alNumB3r',
    }

## Limitations

This module has been tested on Ubuntu 14.04 LTS and Mac OS X Yosemite

Reverse tethering has been tested on:
- HTC Desire X
- Google Nexus 5
- Google Nexus 7

## Contributors

Christopher Johnson - cjohn@ceh.ac.uk
