//
//  ViewController.m
//  JigsawPuzzle
//
//  Created by huang huijing on 10/5/13.
//  Copyright (c) 2013 huang huijing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSInteger pieceNum;
@property (strong,nonatomic) NSMutableArray* targets;
@property (strong,nonatomic) NSMutableArray* pieces;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pieceNum = 25;
    
    // get the picture
    NSString* profilePath = [[NSBundle mainBundle]pathForResource:@"minions" ofType:@"jpg"];
    UIImage* profile = [UIImage imageWithContentsOfFile:profilePath];
    NSString* targetPath = [[NSBundle mainBundle]pathForResource:@"target" ofType:@"png"];
    UIImage* targetImage = [UIImage imageWithContentsOfFile:targetPath];
    
    // parameter
    NSInteger pieceNum = 25;
    CGFloat sideLength = 200/sqrt(pieceNum);
    
    // create a target view
    CGRect targetRect = CGRectMake(60, 60, 200, 200);
    [self createTargetViewInRect: targetRect WithImage: targetImage andNum: pieceNum andSideLen: sideLength];
    
    // create piece view
    CGRect pieceRect = CGRectMake(20, 300, 280, 160);
    [self createPieceViewInRect: pieceRect WithImage: profile andNum: pieceNum andSideLen: sideLength];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// lazy instantiation
-(NSMutableArray*)targets{
    if (!_targets) {
        _targets = [[NSMutableArray alloc] init];
    }
    return _targets;
}

-(NSMutableArray*)pieces{
    if (!_pieces) {
        _pieces = [[NSMutableArray alloc]init];
    }
    return _pieces;
}

// create a target view
-(void)createTargetViewInRect: (CGRect)targetRect WithImage: (UIImage*)image
                       andNum: (NSInteger)pieceNum andSideLen: (CGFloat)sideLength{
    int count = 0; // count the id
    CGFloat x = targetRect.origin.x;
    CGFloat y = targetRect.origin.y;
    NSInteger col = (NSInteger)(targetRect.size.width/sideLength); // calculate the column number
    NSInteger row = (NSInteger)(targetRect.size.height/sideLength); // calculate the row number
    for (int i = 0; i < row; i++) {
        x = targetRect.origin.x; // begin from the left most
        for (int j = 0; j < col; j++) {
            TargetView* target = [[TargetView alloc]initWithFrame:CGRectMake(x, y, sideLength, sideLength)];
            target.image = image;
            target.targetId = count;
            [self.view addSubview:target];
            [self.targets addObject:target];
            count++;
            x = x + sideLength;
        }
        y = y + sideLength;
    }
}

// create a piece view
-(void)createPieceViewInRect: (CGRect)pieceRect WithImage: (UIImage*)image
                      andNum: (NSInteger)pieceNum andSideLen: (CGFloat)sideLength{
    int count = 0;
    // init a mutableArray with integer from 0 to pieceNum-1
    NSMutableArray* idArray = [[NSMutableArray alloc]initWithCapacity:pieceNum];
    for (int i = 0; i < pieceNum; i++) {
        NSNumber* iWrapped = [NSNumber numberWithInt:i];
        [idArray addObject:iWrapped];
    }
    NSMutableArray* images = [self splitImageWith: image andPieceNum: pieceNum]; // get the pieces
    CGFloat x = pieceRect.origin.x;
    CGFloat y = pieceRect.origin.y;
    NSInteger col = (NSInteger)(pieceRect.size.width/sideLength);
    NSInteger row = (NSInteger)(pieceRect.size.height/sideLength);
    for (int i = 0; i < row; i++) {
        x = pieceRect.origin.x;
        for (int j = 0; j < col; j++) {
            if (count < pieceNum) {
                PieceView* piece = [[PieceView alloc]initWithFrame:CGRectMake(x, y, sideLength, sideLength)];
                piece.dragDelegate = self;
                int randomIndex = arc4random()%([idArray count]);
                piece.pieceId = [idArray[randomIndex] intValue];
                piece.image = images[piece.pieceId];
                [idArray removeObjectAtIndex:randomIndex]; // remove the index after using
                [self.view addSubview:piece];
                [self.pieces addObject:piece];
                count ++;
                x = x + sideLength;
            }
        }
        y = y + sideLength;
    }
}

// split the image into N pieces and return an array
- (NSMutableArray *)splitImageWith: (UIImage *)image andPieceNum: (NSInteger)pieceNum{
    NSMutableArray* images = [NSMutableArray arrayWithCapacity:pieceNum];
    NSInteger side = sqrt(pieceNum);
    CGFloat x = 0.0, y = 0.0;
    CGFloat imageWidth = image.size.width/side;
    CGFloat imageHeight = image.size.height/side;
    for (int row = 0; row < side ; row++) {
        x = 0.0;
        for (int col = 0; col < side; col++) {
            CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);
            CGImageRef cImage = CGImageCreateWithImageInRect([image CGImage],  rect);
            UIImage* dImage = [[UIImage alloc]initWithCGImage:cImage];
            [images addObject:dImage];
            x = x + imageWidth;
        }
        y = y + imageHeight;
    }
    return images;
}

// if a piece is drag, check if it matches the target
-(void)pieceView:(PieceView*)pieceView didDragToPoint: (CGPoint)pt{
    TargetView* targetView = nil;
    for (TargetView* tv in self.targets) {
        if (CGRectContainsPoint(tv.frame, pt)) {
            targetView = tv;
            break;
        }
    }
    if (targetView != nil) {
        // if correct, add one point, else 0 point
        //[self placePiece:pieceView atTarget:targetView];
        pieceView.center = targetView.center;
//        NSLog(@"piece id: %i, target id:%i",pieceView.pieceId,targetView.targetId);
        if (pieceView.pieceId == targetView.targetId) {
            pieceView.isMatched = true;
//            NSLog(@"%i, ture",pieceView.pieceId);
        }else{
            pieceView.isMatched = false;
//            NSLog(@"%i, false",pieceView.pieceId);
        }
    }
    int count = 0;
    for (PieceView* pv in self.pieces){
        if (pv.isMatched) count++;
//        else NSLog(@"%i, false",tv.targetId);
    }
    NSLog(@"%i",count);
    // check if all the pieces are matched
    if (count == self.pieceNum) {
        for(PieceView* pv in self.pieces) pv.userInteractionEnabled = NO;
        for(TargetView* tv in self.targets) tv.hidden = YES;
        NSLog(@"What a lovely girl!");
    }
}

// animation: place piece at target
-(void)placePiece:(PieceView*)pieceView atTarget:(TargetView*)targetView{
    [UIView animateWithDuration:1.00 delay:0.00 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         pieceView.center = targetView.center;
                         pieceView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                     }];
}

@end
