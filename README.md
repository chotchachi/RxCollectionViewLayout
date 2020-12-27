# RxCollectionViewLayout

[![CocoaPods](https://img.shields.io/cocoapods/v/RxCollectionViewLayout.svg)](https://cocoapods.org/pods/RxCollectionViewLayout)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)](https://developer.apple.com/swift/)

![Animation](https://raw.githubusercontent.com/chotchachi/RxCollectionViewLayout/main/Screenshots/app-screenshot.gif)

## Example

To run the example project, clone the repo, and run `RxCollectionViewLayoutExampleApp`  scheme from RxCollectionViewLayout.xcworkspace

## Requirements

- iOS 11.0+
- Xcode 9

## Usage

The implementation is the same as RxDataSource - **https://github.com/RxSwiftCommunity/RxDataSources**

```swift   
let collectionViewLayout = RxCollectionViewGridLayout<SectionModel<Void, ItemOrNativeAd<Int, Int>>> (
            numberOfColumns: {
                (viewLayout, collectionView) -> Int in
                return 3
            },
            configureColumnSpan: {
                (viewLayout, collectionView, indexPath, item) -> Int in
                switch item {
                case .item:
                    return 1
                case .ad:
                    return 3
                }
            },
            heightForRow: {
                (viewLayout, collectionView, indexPath, item) -> CGFloat in
                return (collectionView.frame.size.width/3)
            },
            alignmentForSection: {
                (viewLayout, collectionView, section) -> GridCollectionViewLayout.Alignment in
                return .center
            }
        )
```

Turn your data into an Observable sequence
Bind the data to the collectionView using:
  - `collectionView.rx.items(layout:protocol<RxCollectionViewLayoutType, GridCollectionViewLayoutDelegate>)`
  
```swift
let itemsObs = Observable.just(Array(1...30))
let adsObs = Observable.just(Array(1...10))
        
Observable.combineLatest(itemsObs, adsObs) { self.merge(items: $0, with: $1) }
    .do { self.items = $0 }
    .map{ [SectionModel(model: (), items: $0)] }
    .bind(to: self.collectionView.rx.items(layout: collectionViewLayout))
    .disposed(by: disposeBag)
```

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
