//
//  RxCollectionViewGridLayout.swift
//  ios-wallpapers
//
//  Created by FoxCode on 26/12/2020.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    public func items<Layout: RxCollectionViewLayoutType & GridCollectionViewLayoutDelegate, Source: ObservableType>
    (layout: Layout)
    -> (_ source: Source)
    -> Disposable where Layout.Element == Source.Element {
        return {
            return $0.subscribeProxyLayout(ofObject: self.base, layout: layout, retainDataSource: true) { [weak collectionView = self.base] (_: RxGridCollectionViewLayoutDelegateProxy, event) in
                guard let collectionView = collectionView else { return }
                layout.collectionView(collectionView, observedEvent: event)
            }
        }
    }
}

extension ObservableType {
    func subscribeProxyLayout<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, layout: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<Element>) -> Void)
    -> Disposable
    where DelegateProxy.ParentObject: UIView
    {
        let proxy = DelegateProxy.proxy(for: object)
        let unregisterDelegate = DelegateProxy.installForwardDelegate(layout, retainDelegate: retainDataSource, onProxyForObject: object)
        
        object.layoutIfNeeded()
        
        let subscription = self.asObservable()
            .observeOn(MainScheduler())
            .catchError { error in
                debugPrint("Binding error: \(error)")
                return Observable.empty()
            }
            .concat(Observable.never())
            .takeUntil(object.rx.deallocated)
            .subscribe { (event: Event<Element>) in
                binding(proxy, event)
                
                switch event {
                case .error(let error):
                    debugPrint("Binding error: \(error)")
                    unregisterDelegate.dispose()
                case .completed:
                    unregisterDelegate.dispose()
                default:
                    break
                }
            }
        
        return Disposables.create { [weak object] in
            subscription.dispose()
            object?.layoutIfNeeded()
            unregisterDelegate.dispose()
        }
    }
}
