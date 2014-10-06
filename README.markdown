# Selendroid
[![Build Status](https://travis-ci.org/NERC-CEH/puppet-selendroid.svg?branch=master)](https://travis-ci.org/NERC-CEH/puppet-selendroid)
## Overview

This is the selendroid module. It sets up a selendroid server.

## Module Description

[Selendroid](selendroid.io) is a WedDriver server for android devices

This selendroid module will obtain an installation of the selendroid standalone server
from a nexus server and configure the server to run as a service under the selendroid user.

It will not obtain the android sdk or java. Both of which are required for the server to run.

### Reverse Tethering

The selendroid module is capable of setting up reverse tethering for your android device. In 
order for this to work your device *must be rooted*. If you do not require reverse you can 
disable it by default by setting $reverse_tether to false on the selendroid class.

Reverse tethering is configured to automatically set up when a device is connected to the host
pc.

## Setup

### What Selendroid affects

* Creates a service which is named selendroid by default
* Manages a selendroid user and group. Used for running the server
* Takes ownership of USB Devices (for the selendroid user)
* Configures reverse tethering of the devices
* Runs on port 4444 by default

## Usage

Create a Selendroid server

    class { 'selendroid' :
      java_home     => 'location/to/java/jdk',
      android_home  => 'location/to/android/sdk',
      nexus         => 'http://your.nexus.com/server',
    }

Manage a vendor usb device
   
    selendroid::device { 'GoogleNexus5' :
      vendor        => '18d1',
      serial_number => 'S31alNumB3r',
    }

## Limitations

This module has been tested on ubuntu 14.04 lts

## Contributors

Christopher Johnson - cjohn@ceh.ac.uk