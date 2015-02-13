//
//  ELYViewController.m
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 4/27/14.
//  Copyright (c) 2014 Elysian Fields. All rights reserved.
//

#import "ELYViewController.h"
#import "ELYCollectionViewCircleLayout.h"
#import "ELYCollectionViewCell.h"
#import "ELYColorPickerFlowLayout.h"

@interface ELYViewController ()

@property (nonatomic, assign) NSUInteger cellCount;

@end

NSString *kELYCollectionViewCellReuseIdentifier = @"ELYCollectionViewCellReuseIdentifier";

@implementation ELYViewController

#pragma mark - View Lifycycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self setCellCount:20];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [[self collectionView] addGestureRecognizer:tgr];
    
    [[self collectionView] registerClass:[ELYCollectionViewCell class] forCellWithReuseIdentifier:kELYCollectionViewCellReuseIdentifier];
    [[self collectionView] setCollectionViewLayout:[ELYCollectionViewCircleLayout collectionViewCircleLayout]];
    
    [[self collectionView] reloadData];
    
    
    [[self selectionCollectionView] registerClass:[ELYCollectionViewCell class] forCellWithReuseIdentifier:kELYCollectionViewCellReuseIdentifier];
    [[self selectionCollectionView] setCollectionViewLayout:[ELYColorPickerFlowLayout colorPickerFlowLayout]];
    [[self selectionCollectionView] reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.collectionView]) {
        return [self cellCount];
    } else {
        return 15;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        ELYCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kELYCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        cell.cellColor = [self colorPalette][indexPath.row % 5];
        return cell;
    } else {
        ELYCollectionViewCell *cell = [[self selectionCollectionView] dequeueReusableCellWithReuseIdentifier:kELYCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        cell.cellColor = [self colorPalette][indexPath.row % 5];
        cell.radius = 60.0;
        return cell;
    }
}

#pragma mark - UICollectionView Delegate

#pragma mark - Gesture Handlers

- (void)handleTapGesture:(UITapGestureRecognizer*)sender {
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        CGPoint initialTapPoint = [sender locationInView:[self collectionView]];
        NSIndexPath *tappedCellIndexPath = [[self collectionView] indexPathForItemAtPoint:initialTapPoint];
        
        if (tappedCellIndexPath != nil) {
        
            [self setCellCount:[self cellCount] - 1];
            [[self collectionView] performBatchUpdates:^{
                [[self collectionView] deleteItemsAtIndexPaths:@[tappedCellIndexPath]];
            } completion:nil];
        
        } else {
        
            [self setCellCount:[self cellCount] + 1];
            [[self collectionView] performBatchUpdates:^{
                [[self collectionView] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
            } completion:nil];
        
        }
        
    }
    
}

#pragma mark - Colors

- (NSArray *)colorPalette {
    return [ELYColorDataSource colorScheme];
}

@end
