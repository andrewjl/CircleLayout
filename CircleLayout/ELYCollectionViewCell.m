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
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(ctx, rect);
//    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blackColor] CGColor]));
//    CGContextFillPath(ctx);

    CGRect borderRect = CGRectMake(4.0, 4.0, 30.0, 30.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor redColor] CGColor]));
    CGContextSetLineWidth(context, 2.0);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);

}


@end
