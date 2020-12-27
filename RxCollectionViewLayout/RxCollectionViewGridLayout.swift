//
//  RxCollectionViewGridLayout.swift
//  ios-wallpapers
//
//  Created by FoxCode on 26/12/2020.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

open class RxCollectionViewGridLayout<Section: SectionModelType>: CollectionViewSectionedViewLayout<Section>, RxCollectionViewLayoutType {
    
    public typealias Element = [Section]
    
    open func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        Binder(self) { layout, element in
            #if DEBUG
            layout._layoutBound = true
            #endif
            layout.setSections(element)
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }.on(observedEvent)
    }
}
