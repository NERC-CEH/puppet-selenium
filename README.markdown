# selenium
[![Build Status](https://travis-ci.org/NERC-CEH/puppet-selenium.svg?branch=master)](https://travis-ci.org/NERC-CEH/puppet-selenium)
## Overview

This is the selenium module. It sets up a selenium server.

## Module Description

[Selenium](http://www.seleniumhq.org/) automates browsers. 

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

Create a selenium server

    class { 'selenium' :
      java_home     => 'location/to/java/jdk',
      android_home  => 'location/to/android/sdk',
      nexus         => 'http://your.nexus.com/server',
    }

Manage a vendor usb device
   
    selenium::device { 'GoogleNexus5' :
      vendor        => '18d1',
      serial_number => 'S31alNumB3r',
    }

## Limitations

This module has been tested on ubuntu 14.04 lts

Reverse tethering has been tested on:
- HTC Desire X
- Google Nexus 5
- Google Nexus 7

## Contributors

Christopher Johnson - cjohn@ceh.ac.uk
