//
//  CollectionViewSectionedViewLayout.swift
//  ios-wallpapers
//
//  Created by FoxCode on 26/12/2020.
//

import Foundation
import UIKit
import RxCocoa
import RxDataSources

open class CollectionViewSectionedViewLayout<Section: SectionModelType>: NSObject, GridCollectionViewLayoutDelegate, SectionedViewLayoutType {
    
    public typealias Item = Section.Item
    public typealias Section = Section
    public typealias NumberOfColumns = (CollectionViewSectionedViewLayout<Section>, UICollectionView) -> Int
    public typealias ConfigureColumnSpan = (CollectionViewSectionedViewLayout<Section>, UICollectionView, IndexPath, Item) -> Int
    public typealias HeightForRow = (CollectionViewSectionedViewLayout<Section>, UICollectionView, IndexPath, Item) -> CGFloat
    public typealias AlignmentForSection = (CollectionViewSectionedViewLayout<Section>, UICollectionView, Int) -> GridCollectionViewLayout.Alignment
    public typealias HeightForSupplementaryView = (CollectionViewSectionedViewLayout<Section>, UICollectionView, GridCollectionViewLayout.ElementKind, Int) -> CGFloat
    
    public init(numberOfColumns: @escaping NumberOfColumns,
                configureColumnSpan: @escaping ConfigureColumnSpan,
                heightForRow: @escaping HeightForRow,
                alignmentForSection: @escaping AlignmentForSection = { _,_,_ in .center },
                heightForSupplementaryView: @escaping HeightForSupplementaryView = { _,_,_,_ in 0.0 }) {
        self.numberOfColumns = numberOfColumns
        self.configureColumnSpan = configureColumnSpan
        self.heightForRow = heightForRow
        self.alignmentForSection = alignmentForSection
        self.heightForSupplementaryView = heightForSupplementaryView
    }
    
    public typealias SectionModelSnapshot = SectionModel<Section, Item>
    
    private var _sectionModels: [SectionModelSnapshot] = []

    open var sectionModels: [Section] {
        return _sectionModels.map { Section(original: $0.model, items: $0.items) }
    }

    open subscript(section: Int) -> Section {
        let sectionModel = self._sectionModels[section]
        return Section(original: sectionModel.model, items: sectionModel.items)
    }
    
    open subscript(indexPath: IndexPath) -> Item {
        get {
            return self._sectionModels[indexPath.section].items[indexPath.item]
        }
        set(item) {
            var section = self._sectionModels[indexPath.section]
            section.items[indexPath.item] = item
            self._sectionModels[indexPath.section] = section
        }
    }
    
    open func model(at indexPath: IndexPath) throws -> Any {
        return self[indexPath]
    }
    
    open func setSections(_ sections: [Section]) {
        self._sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
    }
    
    open var numberOfColumns: NumberOfColumns
    open var configureColumnSpan: ConfigureColumnSpan
    open var alignmentForSection: AlignmentForSection
    open var heightForRow: HeightForRow
    open var heightForSupplementaryView: HeightForSupplementaryView
    
    // MARK: - GridCollectionViewLayoutDelegate
    public func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        return self.numberOfColumns(self, collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int {
        return self.configureColumnSpan(self, collectionView, indexPath, self[indexPath])
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        return self.collectionView(collectionView, heightForRow: index.row, inSection: indexPath.section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForRow row: Int, inSection section: Int) -> CGFloat {
        return self.heightForRow(self, collectionView, IndexPath(row: row, section: section), self[IndexPath(row: row, section: section)])
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForSupplementaryView kind: GridCollectionViewLayout.ElementKind, at section: Int) -> CGFloat? {
        return self.heightForSupplementaryView(self, collectionView, kind, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, alignmentForSection section: Int) -> GridCollectionViewLayout.Alignment {
        return self.alignmentForSection(self, collectionView, section)
    }
    
}
