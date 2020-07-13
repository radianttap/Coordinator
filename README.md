[![](https://img.shields.io/github/tag/radianttap/Coordinator.svg?label=current)](https://github.com/radianttap/Coordinator/releases)
![platforms: iOS|tvOS](https://img.shields.io/badge/platform-iOS|tvOS-blue.svg)
[![](https://img.shields.io/github/license/radianttap/Coordinator.svg)](https://github.com/radianttap/Coordinator/blob/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-AD4709.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-fb0006.svg)](https://cocoapods.org)
![](https://img.shields.io/badge/swift-5-223344.svg?logo=swift&labelColor=FA7343&logoColor=white)

# Coordinator

Implementation of _Coordinator_ design pattern. It is *the* application architecture pattern for iOS, carefully designed to fit into UIKit; so much it could easily be `UICoordinator`.

Since this is *core architectural pattern*, it’s not possible to explain its usage with one or two clever lines of code. Give it a day or two; analyze and play around. I’m pretty sure you’ll find it worthy of your time and future projects.

## Installation

### Manually 

My preferred method is to integrate Coordinator into the project manually. Just drag `Coordinator` folder into your project — it‘s only a handful of files.

If you prefer to use dependency managers, see below. 
Releases are tagged with [Semantic Versioning](https://semver.org) in mind.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Coordinator into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Coordinator', 	:git => 'https://github.com/radianttap/Coordinator.git'
```

You must use direct link through `:git` since CocoaPods central repository contains a framework of the same name.[^1]

### Setting up with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Coordinator into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "radianttap/Coordinator"
```

## Documentation

The _why_ and _how_ and...

- the [Pattern](documentation/Pattern.md)
- the [Library](documentation/Library.md)
- the [Class](documentation/Class.md)
- recommended [Implementation](documentation/Implement.md)

### Further reading

On my blog: [Coordinator: the missing pattern in UIKit](http://aplus.rs/2018/coordinator-missing-pattern-uikit/)

Rough [history of development](http://aplus.rs/tags/coordinator/), also on my blog. I did not come up with the library all at once, it was a gradual process as all good things are.

***

Soroush Khanlou: [Coordinators Redux](http://khanlou.com/2015/10/coordinators-redux/)

Andrey Panov: [Coordinators Essential tutorial](https://medium.com/blacklane-engineering/coordinators-essential-tutorial-part-i-376c836e9ba7)

Matthew Wyskiel: [Protocol-Oriented App Coordinators in Swift](https://mattwyskiel.github.io/posts/2016/07/20/protocol-oriented-app-coordinator-swift.html)

Coordinators are fairly old pattern but it was Soroush who brought them under iOS developer spotlight in 2015. My library follows the core idea but employs a different implementation.

***

Bill Dudney, WWDC 2014, session 224: [Core iOS Application Architectural Patterns](https://youtu.be/U5zJY0ODV4w)

Andy Matuschak & Colin Barrett, WWDC 2014, session 229: [Advanced iOS Application Architecture and Patterns](https://youtu.be/C9mFqibrPtA)

I file these two talks under *essential education* for any iOS developer. While not directly associated with Coordinator pattern, you should still carefully watch and listen to understand what it means to “fit inside iOS SDK”.

## License

[MIT](https://choosealicense.com/licenses/mit/), as usual.


[^1]: That framework seems long abandoned and my requests to remove it and thus allow me to publish mine were unsuccessful.