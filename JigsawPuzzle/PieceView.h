//
//  PieceView.h
//  JigsawPuzzle
//
//  Created by huang huijing on 10/5/13.
//  Copyright (c) 2013 huang huijing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PieceView;

@protocol PieceDragDelegateProtocol <NSObject>
-(void)pieceView:(PieceView*)pieceView didDragToPoint: (CGPoint)pt;
@end

@interface PieceView : UIImageView

// piece image and its id
@property (strong,nonatomic) UIImage* pieceImg;
@property (nonatomic)NSInteger pieceId;

@property (nonatomic)BOOL isMatched;

// user touches the piece
@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat yOffset;

// protocol
@property (weak,nonatomic) id<PieceDragDelegateProtocol> dragDelegate;

@end
