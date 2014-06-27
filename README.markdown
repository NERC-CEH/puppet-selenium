# Selendroid
[![Build Status](https://travis-ci.org/NERC-CEH/puppet-selendroid.svg?branch=master)](https://travis-ci.org/NERC-CEH/puppet-selendroid)
## Overview

This is the selendroid module. It sets up a selendroid server.

## Module Description

[Selendroid](selendroid.io) is a WedDriver server for android devices

This selendroid module will obtain an installation of the selendroid standalone server
from a nexus server and configure the server to run as a service under the selendroid user.

It will not obtain the android sdk or java. Both of which are required for the server to run.

## Setup

### What Selendroid affects

* Creates a service which is named selendroid by default
* Manages a selendroid user and group. Used for running the server
* Takes ownership of USB Devices (for the selendroid user)
* Runs on port 4444 by default

## Usage

Create a Selendroid server

    class { 'selendroid' :
      java_home     => 'location/to/java/jdk',
      android_home  => 'location/to/android/sdk',
      nexus         => 'http://your.nexus.com/server',
    }

Manage a vendor usb device
   
    selendroid::device { 'GoogleNexus' :
      vendor => '18d1',
    }

## Limitations

This module has been tested on ubuntu 14.04 lts

## Contributors

Christopher Johnson - cjohn@ceh.ac.uk