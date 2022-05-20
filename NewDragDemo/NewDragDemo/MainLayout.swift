//
//  MainLayout.swift
//  DragDemo
//
//  Created by Allen long on 2022/5/11.
//

import Foundation
import UIKit

class MainLayout: UICollectionViewLayout {
    
    private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    private var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        guard let collectionView = self.collectionView else { return }
        let sections = collectionView.numberOfSections
        
        for sectionIndex in 0 ..< sections {
            let sectionFrame = CGRect(x: kScreenW * CGFloat(sectionIndex) , y: 0 , width: kScreenW , height: kScreenH - adapter(120))
            
            let items = collectionView.numberOfItems(inSection: sectionIndex)
            for itemIndex in 0 ..< items {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let rowIndex = itemIndex/4
                let columnIndex = itemIndex%4
                
                let x = ConstHelper.collectionViewContentInset.left + CGFloat(columnIndex) * (ConstHelper.itemSize.width + ConstHelper.itemSpacing) + sectionFrame.origin.x
                let y = ConstHelper.collectionViewContentInset.top + CGFloat(rowIndex) * ConstHelper.lineSpacing + CGFloat(rowIndex) * (ConstHelper.itemSize.height + ConstHelper.lineSpacing)
                attributes.frame = CGRect(x: x, y: y, width: adapter(80), height: adapter(100))
                cache[indexPath] = attributes
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return .zero }
        return CGSize(width: CGFloat(collectionView.numberOfSections) * collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
            for (_ , attributes) in cache where attributes.frame.intersects(rect){
                visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }
}
