//
//  CompositionalLayout.swift
//  Careeix
//
//  Created by mingmac on 2022/10/07.
//

import Foundation
import UIKit

enum ConpositionalGroupAlignment {
    case vertical
    case horizontal
}

struct CompositionalLayout {
    static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        return item
    }
    
    static func createGroup(alignment: ConpositionalGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, subitems: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        }
    }
    
    static func createGroup(alignment: ConpositionalGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, subitem: NSCollectionLayoutItem, count: Int) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: subitem, count: count)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: subitem, count: count)
        }
    }
}
