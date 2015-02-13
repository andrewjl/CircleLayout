//
//  ELYViewController.h
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 4/27/14.
//  Copyright (c) 2014 Elysian Fields. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELYViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UICollectionView *selectionCollectionView;

@end
