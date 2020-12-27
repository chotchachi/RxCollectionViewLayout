//
//  ViewController.swift
//  RxCollectionViewLayoutExampleApp
//
//  Created by FoxCode on 27/12/2020.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxCollectionViewLayout

enum ItemOrNativeAd<T, N> {
    case item(T, position: Int)
    case ad(N, position: Int)
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let bag = DisposeBag()
    
    var items: [ItemOrNativeAd<Int, Int>] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config CollectionView
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
        
        /// CollectionView Layout
        let viewLayout = RxCollectionViewGridLayout<SectionModel<Void, ItemOrNativeAd<Int, Int>>> (
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
        
        let itemsObs = Observable.just(Array(1...30))
        let adsObs = Observable.just(Array(1...10))
        
        Observable.combineLatest(itemsObs, adsObs) { self.merge(items: $0, with: $1) }
            .do { self.items = $0 }
            .map{ [SectionModel(model: (), items: $0)] }
            .bind(to: self.collectionView.rx.items(layout: viewLayout))
            .disposed(by: self.bag)
        
    }
    
    func merge<T, N>(items: [T], with ads: [N], offSet: Int = 4) -> [ItemOrNativeAd<T, N>] {
        guard !items.isEmpty else {
            return items.enumerated().map { .item($0.element, position: $0.offset) }
        }
        guard !ads.isEmpty else {
            return items.enumerated().map { .item($0.element, position: $0.offset) }
        }
        
        let totalAdsNeeded = 20
        let numberOfSegments = Int((Double(totalAdsNeeded) / Double(ads.count)).rounded(.up))
        let totalAds = Array(Array(repeating: ads, count: numberOfSegments).flatMap { $0 }.prefix(totalAdsNeeded))
        
        var merged: [ItemOrNativeAd<T, N>] = []
        merged.reserveCapacity(totalAds.count + items.count)
        
        var adIndex = 0
        var itemIndex = 0
        while itemIndex < items.count, adIndex < totalAds.count {
            if merged.count % offSet == 0 {
                let ad = totalAds[adIndex]
                merged.append(.ad(ad, position: adIndex))
                adIndex += 1
            } else {
                let item = items[itemIndex]
                merged.append(.item(item, position: itemIndex))
                itemIndex += 1
            }
        }
        
        while itemIndex < items.count {
            let item = items[itemIndex]
            merged.append(.item(item, position: itemIndex))
            itemIndex += 1
        }
        
        if merged.count % offSet == 0, adIndex < totalAds.count {
            let ad = totalAds[adIndex]
            merged.append(.ad(ad, position: adIndex))
        }
        
        print(merged)
        return merged
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        switch self.items[indexPath.row] {
        case .item:
            cell.mainView.backgroundColor = UIColor.random
        case .ad:
            cell.mainView.backgroundColor = .lightGray
        }
        return cell
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
