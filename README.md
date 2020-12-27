# RxCollectionViewLayout

[![CocoaPods](https://img.shields.io/cocoapods/v/RxCollectionViewLayout.svg)](https://cocoapods.org/pods/RxCollectionViewLayout)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)](https://developer.apple.com/swift/)

![Animation](https://raw.githubusercontent.com/chotchachi/RxCollectionViewLayout/main/Screenshots/app-screenshot.gif)

## Example

To run the example project, clone the repo, and run `RxCollectionViewLayoutExampleApp`  scheme from RxCollectionViewLayout.xcworkspace

## Requirements

- iOS 11.0+
- Xcode 9

## Installation

### CocoaPods
To install RxCollectionViewLayout add the following line to your Podfile:
```ruby
pod 'RxCollectionViewLayout'
```
Then run `pod install`.

### Swift Package Manager

Create a `Package.swift` file.

```swift
import PackageDescription

let package = Package(
    name: "SampleProject",
    dependencies: [
        .package(url: "https://github.com/chotchachi/RxCollectionViewLayout.git", from: "0.0.2")
    ]
)
```

If you are using Xcode 11 or higher, go to **File / Swift Packages / Add Package Dependency...** and enter package repository URL **https://github.com/chotchachi/RxCollectionViewLayout.git**, then follow the instructions.

### Manual

Add RxCollectionViewLayout folder to your project
