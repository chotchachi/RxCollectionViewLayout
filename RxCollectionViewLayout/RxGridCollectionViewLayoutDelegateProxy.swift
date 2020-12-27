//
//  RxGridCollectionViewLayoutDelegateProxy.swift
//  ios-wallpapers
//
//  Created by FoxCode on 26/12/2020.
//

import Foundation
import RxSwift
import RxCocoa

private let collectionViewLayoutNotSet = CollectionViewLayoutNotSet()

private final class CollectionViewLayoutNotSet: NSObject, GridCollectionViewLayoutDelegate {
    
    func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForRow row: Int, inSection section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForSupplementaryView kind: GridCollectionViewLayout.ElementKind, at section: Int) -> CGFloat? {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, alignmentForSection section: Int) -> GridCollectionViewLayout.Alignment {
        .center
    }
    
}

open class RxGridCollectionViewLayoutDelegateProxy: DelegateProxy<UICollectionView,  GridCollectionViewLayoutDelegate>, DelegateProxyType, GridCollectionViewLayoutDelegate {
   
    /// Typed parent object.
    public weak private(set) var collectionView: UICollectionView?

    /// - parameter collectionView: Parent object for delegate proxy.
    public init(collectionView: ParentObject) {
        self.collectionView = collectionView
        super.init(parentObject: collectionView, delegateProxy: RxGridCollectionViewLayoutDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxGridCollectionViewLayoutDelegateProxy(collectionView: $0) }
    }
    
    private weak var _requiredMethodsLayout: GridCollectionViewLayoutDelegate? = collectionViewLayoutNotSet

    public static func currentDelegate(for object: UICollectionView) -> GridCollectionViewLayoutDelegate? {
        return (object.collectionViewLayout as? GridCollectionViewLayout)?.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: GridCollectionViewLayoutDelegate?, to object: UICollectionView) {
        let collectionViewLayout = GridCollectionViewLayout()
        collectionViewLayout.delegate = delegate
        object.collectionViewLayout = collectionViewLayout
    }
    
    // MARK: - GridCollectionViewLayoutDelegate
    
    public func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        return (_requiredMethodsLayout ?? collectionViewLayoutNotSet).numberOfColumns(collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int {
        return (_requiredMethodsLayout ?? collectionViewLayoutNotSet).collectionView(collectionView, columnSpanForItemAt: index, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        return (_requiredMethodsLayout ?? collectionViewLayoutNotSet).collectionView(collectionView, heightForItemAt: index, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForRow row: Int, inSection section: Int) -> CGFloat {
        return (_requiredMethodsLayout ?? collectionViewLayoutNotSet).collectionView(collectionView, heightForRow: row, inSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForSupplementaryView kind: GridCollectionViewLayout.ElementKind, at section: Int) -> CGFloat? {
        return (_requiredMethodsLayout ?? collectionViewLayoutNotSet).collectionView(collectionView, heightForSupplementaryView: kind, at: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, alignmentForSection section: Int) -> GridCollectionViewLayout.Alignment {
        return (_requiredMethodsLayout ?? collectionViewLayoutNotSet).collectionView(collectionView, alignmentForSection: section)
    }
    
    open override func setForwardToDelegate(_ delegate: DelegateProxy<UICollectionView, GridCollectionViewLayoutDelegate>.Delegate?, retainDelegate: Bool) {
        _requiredMethodsLayout = delegate ?? collectionViewLayoutNotSet
        super.setForwardToDelegate(delegate, retainDelegate: retainDelegate)
    }
}
