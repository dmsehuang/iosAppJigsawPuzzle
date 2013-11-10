//
//  ViewController.h
//  JigsawPuzzle
//
//  Created by huang huijing on 10/5/13.
//  Copyright (c) 2013 huang huijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "TargetView.h"
#import "PieceView.h"

@interface ViewController : UIViewController <PieceDragDelegateProtocol>

-(void)createTargetViewInRect: (CGRect)targetRect WithImage: (UIImage*)image
                       andNum: (NSInteger)pieceNum andSideLen: (CGFloat)sideLength;
-(void)createPieceViewInRect: (CGRect)pieceRect WithImage: (UIImage*)image
                      andNum: (NSInteger)pieceNum andSideLen: (CGFloat)sideLength;
- (NSMutableArray *)splitImageWith: (UIImage *)image andPieceNum: (int)pieceNum;
-(void)pieceView:(PieceView*)pieceView didDragToPoint: (CGPoint)pt;
//-(void)placePiece:(PieceView*)pieceView atTarget:(TargetView*)targetView;

@end
