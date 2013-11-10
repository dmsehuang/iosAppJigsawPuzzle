//
//  PieceView.m
//  JigsawPuzzle
//
//  Created by huang huijing on 10/5/13.
//  Copyright (c) 2013 huang huijing. All rights reserved.
//

#import "PieceView.h"

@implementation PieceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.isMatched = false;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.superview bringSubviewToFront:self];
    CGPoint pt = [[touches anyObject]locationInView:self.superview];
    self.xOffset = pt.x - self.center.x;
    self.yOffset = pt.y - self.center.y;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject]locationInView:self.superview];
    self.center = CGPointMake(pt.x - self.xOffset, pt.y - self.yOffset);
    if (self.dragDelegate) {
        [self.dragDelegate pieceView:self didDragToPoint:self.center]; // self.center is the pt
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
}

@end
