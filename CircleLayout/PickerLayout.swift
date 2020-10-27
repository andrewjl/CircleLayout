//
//  PickerLayout.swift
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 10/24/20.
//  Copyright © 2020 Elysian Fields. All rights reserved.
//

import UIKit

class PickerLayout: UICollectionViewFlowLayout {
    static let itemSize = CGSize(width: activeDistance,
                                 height: activeDistance)
    static let activeDistance: CGFloat = 125.0
    
    var zoomFactor: CGFloat = 0.3
    var width: CGFloat = 0.0
    
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        let sideInset:CGFloat = (self.width/3) + 75.0
        let topBottomInset: CGFloat = 10.0
        self.sectionInset = UIEdgeInsets(top: topBottomInset,
                                         left: sideInset,
                                         bottom: topBottomInset,
                                         right: sideInset)
        
        if let c = self.collectionView {
            self.width = c.bounds.width
            
            if Self.itemSize.height < (c.bounds.height - (topBottomInset*2.0))*(1-self.zoomFactor) {
                self.itemSize = Self.itemSize
            } else {
                self.itemSize = CGSize(width: (c.bounds.height - (topBottomInset*2.0))*(1-self.zoomFactor),
                                       height: (c.bounds.height - (topBottomInset*2.0))*(1-self.zoomFactor))
            }
        }
        
        self.minimumLineSpacing = 10.0
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        guard let c = self.collectionView else {
            return layoutAttributes
        }
        
        let modifiedLayoutAttributes = layoutAttributes.map { $0.copy() } as! [UICollectionViewLayoutAttributes]
    
        let origin = c.contentOffset
        let size = c.bounds.size
        
        let visibleRect = CGRect(origin: origin, size: size)
        
        for cellAttributes in modifiedLayoutAttributes {
            if cellAttributes.frame.intersects(rect) {
                let distance = visibleRect.midX - cellAttributes.center.x
                let normalizedDistance = abs(distance / Self.activeDistance)
                if abs(distance) < Self.activeDistance {
                    let zoom: CGFloat = 1 + (self.zoomFactor * (1 - normalizedDistance))
                    cellAttributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    cellAttributes.zIndex = Int(zoom.rounded(.up))
                }
            }
        }
        
        return modifiedLayoutAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let c = self.collectionView else {
            return proposedContentOffset
        }
    
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + (c.bounds.width / 2.0)
        
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0.0,
                                width: c.bounds.width,
                                height: c.bounds.height)
        let layoutAttributes = super.layoutAttributesForElements(in: targetRect)!
        
        for cellAttributes in layoutAttributes {
            let itemHorizontalCenter = cellAttributes.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment,
                       y: proposedContentOffset.y)
    }
}
