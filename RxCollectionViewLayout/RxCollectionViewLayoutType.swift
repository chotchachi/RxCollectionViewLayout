//
//  RxCollectionViewLayoutType.swift
//  ios-wallpapers
//
//  Created by FoxCode on 26/12/2020.
//

import UIKit
import RxSwift

/// Marks collection view layout  as `UICollectionView` reactive data source enabling it to be used with one of the `bindTo` methods.
public protocol RxCollectionViewLayoutType {
    
    /// Type of elements that can be bound to collection view.
    associatedtype Element
    
    /// New observable sequence event observed.
    ///
    /// - parameter collectionView: Bound collection view.
    /// - parameter observedEvent: Event
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>)
}
