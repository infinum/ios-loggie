# Loggie

> __IMPORTANT NOTE:__
> 
> Loggie is __deprecated__ and __no longer maintained__. We suggest migrating to [Pulse](https://github.com/kean/pulse) as an alternative. Pulse is more powerful and flexible then Loggie.

[![Build Status](https://github.com/infinum/ios-loggie/actions/workflows/ci.yml/badge.svg)](https://github.com/infinum/ios-loggie/actions/workflows/ci.yml)
[![Version](https://img.shields.io/cocoapods/v/Loggie.svg?style=flat)](http://cocoapods.org/pods/Loggie)
[![License](https://img.shields.io/cocoapods/l/Loggie.svg?style=flat)](http://cocoapods.org/pods/Loggie)
[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/cocoapods/p/Loggie.svg?style=flat)](http://cocoapods.org/pods/Loggie)

<p align="center">
    <img src="./Resources/icon.svg" width="300" max-width="50%" alt="Loggie"/>
</p>

## About

**Loggie** is a simple in-app network logging library that gives the developers and the QA testers a possibility to log network. The library is handy for easily accessible list of network trafic.

## Requirements

- Xcode 10
- iOS 11

## Installation

### CocoaPods
Loggie is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Loggie'
```

By default, network debugging will be available for the `URLSession`. If you want to use Loggie with Alamofire, please use:

```ruby
pod 'Loggie/Alamofire'
```

### Swift Package Manager
If you are using SPM for your dependency manager, add this to the dependencies in your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/infinum/ios-loggie.git")
]
```

## Example

To run the example project, clone the repo, and run `pod install` from the Examples/Cocoapods directory first.

## Usage

**1. Register custom `LoggieURLProtocol` in the `application:didFinishLaunchingWithOptions` method:**

```swift
// Swift
URLProtocol.registerClass(LoggieURLProtocol.self)
```

```objective-c
// Objective-C
[NSURLProtocol registerClass:[LoggieURLProtocol class]];
```

**2. If you use `NSURLSession` (or AFNetworking/Alamofire) make sure that you use `loggieSessionConfiguration`:**

```swift
// Swift
URLSession(configuration: URLSessionConfiguration.loggie)
```

```objective-c
// Objective-C
[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration loggieSessionConfiguration]];
```

**3. At the point where you want to display network logs, you can just put the following line:**

```swift
// Swift
LoggieManager.shared.showLogs(from: viewController)
```

```objective-c
// Objective-C
[[LoggieManager sharedManager] showLogsFromViewController:viewController filter:nil];
```

**You can create custom output or UI to show network logs. To get an array of all network logs just call:**

```swift
// Swift
let logs = LoggieManager.shared.logs
```

```objective-c
// Objective-C
NSArray<Log *> *array = [[LoggieManager sharedManager] logs];
```

If you would like to receive notifications when new logs are added to the list, your app can observe `LoggieDidUpdateLogs` notification.

## Important

Please make sure that `LogieURLProtocol` and `loggieSessionConfiguration` are not used in production builds.

## Author

Filip Beć, filip.bec@gmail.com

## Credits

Maintained and sponsored by [Infinum](http://www.infinum.co).

![Infinum logo](https://cloud.githubusercontent.com/assets/1422973/24369980/9c36b0a6-12da-11e7-898a-b711ed7ca52f.png)

## License

Loggie is available under the MIT license. See the `LICENSE` file for more information.
