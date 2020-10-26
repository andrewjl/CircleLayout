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
    
    var selectedColor: UIColor?
    
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        self.cellCount = 25
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
        self.cellCount = 25
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
        self.pickerCollectionView.register(CircleCell.self, forCellWithReuseIdentifier: CircleCell.reuseIdentifier)
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
        self.circleCollectionView.backgroundColor = .tertiarySystemBackground
        
        self.view.addSubview(self.pickerCollectionView)
        self.pickerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.circleCollectionView)
        self.circleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.circleCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.circleCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.circleCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.circleCollectionView.bottomAnchor.constraint(equalTo: self.pickerCollectionView.topAnchor).isActive = true
        
        self.pickerCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pickerCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.pickerCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.pickerCollectionView.topAnchor.constraint(equalTo: self.circleCollectionView.bottomAnchor).isActive = true
        
        let pickerHeightMultiplier: CGFloat = 0.15
        let circleHeightMultiplier = (1.0 - pickerHeightMultiplier)
        
        self.circleCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                                          multiplier: circleHeightMultiplier).isActive = true
        self.pickerCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                                          multiplier: pickerHeightMultiplier).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.circleCollectionView.reloadData()
        self.pickerCollectionView.reloadData()
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
        
        if let c = self.selectedColor {
            cell.color = indexPath.row == 0 ? c : UIColor.colorScheme()[indexPath.row % 5]
        } else {
            cell.color = UIColor.colorScheme()[indexPath.row % 5]
        }
        
        if collectionView == self.pickerCollectionView {
            let layout = collectionView.collectionViewLayout as! PickerLayout
            cell.radius = layout.itemSize.height * 0.85
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = self.pickerCollectionView.center
        let origin = self.pickerCollectionView.frame.origin
        let contentOffset = self.pickerCollectionView.contentOffset
        let offsetCenter = CGPoint(x: center.x - origin.x + contentOffset.x,
                                   y: center.y - origin.y + contentOffset.y)
        
        
        if let selectedIndexPath = self.pickerCollectionView.indexPathForItem(at: offsetCenter) {
            
            self.selectedColor = UIColor.colorScheme()[selectedIndexPath.row]
        }
    }
}
