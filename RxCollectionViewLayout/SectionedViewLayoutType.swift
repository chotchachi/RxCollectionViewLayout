//
//  SectionedViewLayoutType.swift
//  ios-wallpapers
//
//  Created by FoxCode on 26/12/2020.
//

import Foundation

/// Collection view layout with access to underlying sectioned model.
public protocol SectionedViewLayoutType {
    /// Returns model at index path.
    ///
    /// In case data source doesn't contain any sections when this method is being called, `RxCocoaError.ItemsNotYetBound(object: self)` is thrown.

    /// - parameter indexPath: Model index path
    /// - returns: Model at index path.
    func model(at indexPath: IndexPath) throws -> Any
}
