# LinkedLog Xcode Plugin

LinkedLog is a Xcode plugin that includes a Xcode PCH file template that adds the macros `LLog` and `LLogF`.
The `LLog` macro will work like `NSLog` but additionally prints the file name and line number of the call.

LinkedLog then parses the logs and adds links to the corresponding file and line.


## Status

[![Stories ToDo](https://badge.waffle.io/julian-weinert/linkedlog.svg?label=todo&title=ToDo)](http://waffle.io/julian-weinert/linkedlog)
[![Stories in Progress](https://badge.waffle.io/julian-weinert/linkedlog.svg?label=progress&title=In%20Progress)](http://waffle.io/julian-weinert/linkedlog)
[![Stories Done](https://badge.waffle.io/julian-weinert/linkedlog.svg?label=done&title=Done)](http://waffle.io/julian-weinert/linkedlog)

[![Build Status](https://travis-ci.org/julian-weinert/LinkedLog.svg?branch=master)](https://travis-ci.org/julian-weinert/LinkedLog)
[![LinkedLog chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/julian-weinert/LinkedLog?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


## Install

1. Build the project to install the plugin. The plugin gets installed in `/Library/Application Support/Developer/Shared/Xcode/Plug-ins/LinkedLog.xcplugin`.
2. Restart Xcode for the plugin to be activated.

**Alternatively, install it using [Alcatraz plugin manager](https://github.com/supermarin/Alcatraz).**


## Configuration

* In Xcode select add files to the project.
* Select the *PCH File+LLog* file template from the *LinkedLog templates* section.
* Navigate to your build settings, search for **prefix** and add the created file to "Prefix header"
* Replace all `NSLog` calls with `LLog` or `LLogF`


## Usage

Whenever you want a log message, use `LLog(@"string with format: %@", @"'format'");` just as `NSLog`.
The messages will be omitted when building without `DEBUG` build variable.
To force logs to also appear with production build configs use `LLogF` instead.


## Screenshot

![LinkedLog](https://raw.githubusercontent.com/julian-weinert/LinkedLog/master/Screenshots/LinkedLog.png)


## Bugs and limitations


### Pull requests

If you want to contribute, send me a pull request.


### Improvements

[![Stories ToDo](https://badge.waffle.io/julian-weinert/linkedlog.svg?label=todo&title=ToDo)](http://waffle.io/julian-weinert/linkedlog)
