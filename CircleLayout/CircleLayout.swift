//
//  CircleLayout.swift
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 10/23/20.
//  Copyright © 2020 Elysian Fields. All rights reserved.
//

import UIKit

let itemRadius:CGFloat = 50.0

class CircleLayout: UICollectionViewLayout {
    var cellCount: Int
    var center: CGPoint
    var layoutRadius: CGFloat
    
    var deleted: [IndexPath] = []
    var inserted: [IndexPath] = []
    
    override init() {
        self.cellCount = 25
        self.center = .zero
        self.layoutRadius = itemRadius * 5
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.cellCount = 25
        self.center = .zero
        self.layoutRadius = itemRadius * 5
        super.init(coder: coder)
    }
    
    override func prepare() {
        super.prepare()
        
        if let c = self.collectionView {
            self.cellCount = c.numberOfItems(inSection: 0)
            
            let size = c.bounds.size
            self.center = CGPoint(x: size.width/2, y: size.height/2)
            self.layoutRadius = min(size.width, size.height) / 2.5
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return self.collectionView?.bounds.size ?? .zero
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        (0..<self.cellCount).forEach { attributes.append(self.layoutAttributesForItem(at: IndexPath(item: Int($0), section: 0))!) }
        
        
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = CGSize(width: itemRadius, height: itemRadius)
    
        let x = self.center.x + layoutRadius * cos(2.0 * CGFloat(indexPath.item) * CGFloat.pi / CGFloat(self.cellCount))
        let y = self.center.y + layoutRadius * sin(2.0 * CGFloat(indexPath.item) * CGFloat.pi / CGFloat(self.cellCount))
        attributes.center = CGPoint(x: x, y: y)
        
        return attributes
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        self.deleted = []
        self.inserted = []
        
        for updateItem in updateItems {
            if updateItem.updateAction == .delete {
                self.deleted.append(updateItem.indexPathBeforeUpdate!)
            } else if updateItem.updateAction == .insert {
                self.inserted.append(updateItem.indexPathAfterUpdate!)
            }
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.layoutAttributesForItem(at: itemIndexPath)
        
        if self.inserted.contains(itemIndexPath) {
            
            if attributes == nil {
                attributes = self.layoutAttributesForItem(at: itemIndexPath)
            }
        
            attributes?.alpha = 0.0
            attributes?.center = CGPoint(x: self.center.x,
                                         y: self.center.y)
        }
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        if self.deleted.contains(itemIndexPath) {
            if attributes == nil {
                attributes = self .initialLayoutAttributesForAppearingItem(at: itemIndexPath)
            }
            
            attributes?.alpha = 0.0
            attributes?.center = self.center
            attributes?.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0)
        }
        
        return attributes
    }
}


