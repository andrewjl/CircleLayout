//
//  CircleViewController.swift
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 10/24/20.
//  Copyright © 2020 Elysian Fields. All rights reserved.
//

import UIKit

final class TargetAction {
    let execute: (Any) -> ()
    init(_ execute: @escaping (Any) -> ()) {
        self.execute = execute
    }
    
    @objc func action(_ sender: Any) {
        self.execute(sender)
    }
}

class CircleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var targetAction: TargetAction?
    
    var circleCollectionView: UICollectionView
    var pickerCollectionView: UICollectionView
    
    var cellCount: Int
    
    var selectedIndexPath: IndexPath?
    
    var circleCompactHeightAnchor: NSLayoutConstraint?
    var pickerCompactHeightAnchor: NSLayoutConstraint?
    
    var circleRegularHeightAnchor: NSLayoutConstraint?
    var pickerRegularHeightAnchor: NSLayoutConstraint?
    
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        self.cellCount = 15
        let circleLayout = CircleLayout()
        self.circleCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: circleLayout)
                                                     
        let pickerLayout = PickerLayout()
        self.pickerCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: pickerLayout)
        
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.cellCount = 15
        let circleLayout = CircleLayout()
        self.circleCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: circleLayout)
                                                     
        let pickerLayout = PickerLayout()
        self.pickerCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: pickerLayout)
        super.init(coder: coder)
        
        self.setup()
    }
    
    func setup() {
        self.circleCollectionView.dataSource = self
        circleCollectionView.register(CircleCell.self,
                                      forCellWithReuseIdentifier: CircleCell.reuseIdentifier)
        
        let ta = TargetAction { sender in
            if let tgr = sender as? UITapGestureRecognizer {
                
                if tgr.state == .ended {
                    let initialTap = tgr.location(in: self.circleCollectionView)
                    if let tappedIndexPath = self.circleCollectionView.indexPathForItem(at: initialTap) {
                        self.cellCount = self.cellCount - 1
                        self.circleCollectionView.performBatchUpdates({
                            self.circleCollectionView.deleteItems(at: [tappedIndexPath])
                        }, completion: nil)
                    } else {
                        self.cellCount = self.cellCount + 1
                        self.circleCollectionView.performBatchUpdates({
                            let insertedIndexPath = IndexPath(item: 0, section: 0)
                            self.circleCollectionView.insertItems(at: [insertedIndexPath])
                        }, completion: nil)
                    }
                }
            }
        }
        let tgr = UITapGestureRecognizer(target: ta,
                                         action: #selector(TargetAction.action(_:)))
        self.targetAction = ta
        self.circleCollectionView.addGestureRecognizer(tgr)
        
        self.pickerCollectionView.dataSource = self
        self.pickerCollectionView.delegate = self
        self.pickerCollectionView.register(CircleCell.self,
                                           forCellWithReuseIdentifier: CircleCell.reuseIdentifier)
        self.pickerCollectionView.showsHorizontalScrollIndicator = false
        self.pickerCollectionView.contentInset = UIEdgeInsets(top: 0.0,
                                                              left: 22.0,
                                                              bottom: 0.0,
                                                              right: 22.0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.pickerCollectionView.backgroundColor = .secondarySystemBackground
        self.circleCollectionView.backgroundColor = .secondarySystemBackground
        
        self.view.addSubview(self.pickerCollectionView)
        self.pickerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.circleCollectionView)
        self.circleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.circleCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.circleCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.circleCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.circleCollectionView.bottomAnchor.constraint(equalTo: self.pickerCollectionView.topAnchor).isActive = true
        
        self.pickerCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pickerCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.pickerCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.pickerCollectionView.topAnchor.constraint(equalTo: self.circleCollectionView.bottomAnchor).isActive = true
        
        let pickerCompactHeightMultiplier: CGFloat = 0.35
        let circleCompactHeightMultiplier = (1.0 - pickerCompactHeightMultiplier)
        
        let circleCompactHeightAnchor = self.circleCollectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor,
                                                                                   multiplier: circleCompactHeightMultiplier)
        
        
        let pickerCompactHeightAnchor = self.pickerCollectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor,
                                                                                   multiplier: pickerCompactHeightMultiplier)
        
        
        self.circleCompactHeightAnchor = circleCompactHeightAnchor
        self.pickerCompactHeightAnchor = pickerCompactHeightAnchor
        
    
        let pickerRegularHeightMultiplier: CGFloat = 0.15
        let circleRegularHeightMultiplier = (1.0 - pickerRegularHeightMultiplier)
        
        let circleRegularHeightAnchor = self.circleCollectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor,
                                                                                   multiplier: circleRegularHeightMultiplier)
        
        
        let pickerRegularHeightAnchor = self.pickerCollectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor,
                                                                                   multiplier: pickerRegularHeightMultiplier)
        
        
        self.circleCompactHeightAnchor = circleCompactHeightAnchor
        self.pickerCompactHeightAnchor = pickerCompactHeightAnchor
    
        self.circleRegularHeightAnchor = circleRegularHeightAnchor
        self.pickerRegularHeightAnchor = pickerRegularHeightAnchor
        
        if self.traitCollection.verticalSizeClass == .compact {
            self.circleCompactHeightAnchor?.isActive = true
            self.pickerCompactHeightAnchor?.isActive = true
        } else {
            self.circleRegularHeightAnchor?.isActive = true
            self.pickerRegularHeightAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.circleCollectionView {
            return self.cellCount
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCell.reuseIdentifier,
                                                      for: indexPath) as! CircleCell
        
        if collectionView == self.circleCollectionView && indexPath.row == 0 {
            if let s = self.selectedIndexPath {
                cell.color = UIColor.colorScheme()[s.row]
            } else {
                cell.color = UIColor.colorScheme()[0]
            }
        } else {
            cell.color = UIColor.colorScheme()[indexPath.row % 5]
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let center = self.pickerCollectionView.center
        let origin = self.pickerCollectionView.frame.origin
        
        let targetOffsetCenter = CGPoint(x: center.x - origin.x + targetContentOffset.pointee.x,
                                         y: center.y - origin.y + targetContentOffset.pointee.y)
        if let s = self.pickerCollectionView.indexPathForItem(at: targetOffsetCenter) {
            self.selectedIndexPath = s
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.pickerCollectionView.collectionViewLayout.invalidateLayout()
        self.circleCollectionView.collectionViewLayout.invalidateLayout()
        
        if let ptc = previousTraitCollection {
            if ptc.verticalSizeClass != self.traitCollection.verticalSizeClass {
                if self.traitCollection.verticalSizeClass == .compact {
                    self.circleRegularHeightAnchor?.isActive = false
                    self.pickerRegularHeightAnchor?.isActive = false
                    
                    self.circleCompactHeightAnchor?.isActive = true
                    self.pickerCompactHeightAnchor?.isActive = true
                } else {
                    self.pickerCompactHeightAnchor?.isActive = false
                    self.circleCompactHeightAnchor?.isActive = false
                    
                    self.pickerRegularHeightAnchor?.isActive = true
                    self.circleRegularHeightAnchor?.isActive = true
                }
                self.view.setNeedsLayout()
                
                if let s = self.selectedIndexPath {
                    self.pickerCollectionView.scrollToItem(at: s,
                                                           at: .centeredHorizontally,
                                                           animated: true)
                }
            }
        }
    }
}
