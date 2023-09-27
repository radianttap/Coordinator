[![](https://img.shields.io/github/tag/radianttap/Coordinator.svg?label=current)](https://github.com/radianttap/Coordinator/releases)
![platforms: iOS|tvOS](https://img.shields.io/badge/platform-iOS|tvOS-blue.svg)
[![](https://img.shields.io/github/license/radianttap/Coordinator.svg)](https://github.com/radianttap/Coordinator/blob/master/LICENSE)
[![SwiftPM ready](https://img.shields.io/badge/SwiftPM-ready-FA7343.svg?style=flat)](https://swift.org/package-manager/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-AD4709.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-fb0006.svg)](https://cocoapods.org)
![](https://img.shields.io/badge/swift-5-223344.svg?logo=swift&labelColor=FA7343&logoColor=white)

# Coordinator

Implementation of _Coordinator_ design pattern. It is *the* application architecture pattern for iOS, carefully designed to fit into UIKit; so much it could easily be `UICoordinator`.

Since this is *core architectural pattern*, it’s not possible to explain its usage with one or two clever lines of code. Give it a day or two; analyze and play around. I’m pretty sure you’ll find it worthy of your time and future projects.

## Installation

- version 7.x and up is made with Swift 5.5 concurrency in mind (async / awai)
- versions before that (6.x) use closures

### Manually 

Just drag `Coordinator` folder into your project — it‘s only a handful of files.

If you prefer to use dependency managers, see below. 
Releases are tagged with [Semantic Versioning](https://semver.org) in mind.

### Swift Package Manager 

Ready, just add this repo URL as Package. 

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Coordinator into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Coordinator', 	:git => 'https://github.com/radianttap/Coordinator.git'
```

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

## License

[MIT](https://choosealicense.com/licenses/mit/), as usual.

## Give back

If you found this code useful, please consider [buying me a coffee](https://www.buymeacoffee.com/radianttap) or two. ☕️😋
