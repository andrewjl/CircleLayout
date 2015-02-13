//
//  ELYCollectionViewCell.m
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 4/27/14.
//  Copyright (c) 2014 Elysian Fields. All rights reserved.
//

#import "ELYCollectionViewCell.h"

@implementation ELYCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    UIColor *cellColor = self.cellColor ? self.cellColor : [UIColor redColor];

    CGRect borderRect = CGRectMake(4.0, 4.0, self.radius, self.radius);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetFillColor(context, CGColorGetComponents([cellColor CGColor]));
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);

}

- (CGFloat)radius {
    
    if (!_radius) {
        _radius = 40.0;
    }
    
    return _radius;
    
}

@end
