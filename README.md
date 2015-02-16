# LinkedLog Xcode Plugin

LinkedLog is a Xcode plugin that includes a Xcode PCH header file template that adds the macros `LLog` and `LLogF`.
The `LLog` macro will work like `NSLog` but additionally prints the file name and line number of the call.

LinkedLog then parses the logs and adds links the the corresponding file and line.

[![Build Status](https://travis-ci.org/julian-weinert/LinkedLog.svg?branch=master)](https://travis-ci.org/julian-weinert/LinkedLog)


## Install

1. Build the project to install the plugin. The plugin is installed in `/Library/Application Support/Developer/Shared/Xcode/Plug-ins/LinkedLog.xcplugin`.

2. Restart Xcode for the plugin to be activated.

~~Alternatively, install through [Alcatraz](https://github.com/supermarin/Alcatraz) plugin manager.~~ (Not yet)


## Configuration

* In Xcode select add files to the project.
* Select the *PCH File+LLog* file template from the *LinkedLog templates* section.
* Navigate to your build settings, search for **prefix** and add the created file to "Prefix header"
* Replace all `NSLog` called with `LLog` or `LLogF`


## Usage

Whenever you want a log message, use `LLog(@"string with format: %@", @"'format'");` just as `NSLog`.
The messages will be omitted when building without `DEBUG` build variable.
To force logs to also appear in production build use `LLogF` instead.


## Screenshot

![LinkedLog](https://raw.githubusercontent.com/julian-weinert/LinkedLog/master/Screenshots/LinkedLog.png)


## Bugs and limitations

* The `LLog` and `LLogF` macros are currently not supported in iOS.


### Pull requests

If you want to contribute, send me a pull request.


### Improvements

Ideas of improvements:

* iOS support
* Better way to inject the `LLog` macros (requires adding PCH file for now)
