//
//  SetCardView.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import <UIKit/UIKit.h>
#import "Color.h"
#import "Shape.h"
#import "Shade.h"

@interface SetCardView : UIView

- (void)cardChosenAnimation;
- (void)cardMatchAnimation;
- (void)cardDisappearAnimation;
- (void)cardDealAnimationToRect: (CGRect)rect;
- (void)cardSpringAnimation: (BOOL)isSuccess;

@property (strong, nonatomic) Color *color;
@property (strong, nonatomic) Shape *shape;
@property (strong, nonatomic) Shade *shade;
@property (nonatomic)NSInteger numberOfShapes;
@property (nonatomic)BOOL isChosen;
@property (nonatomic)BOOL isMatched;
@property (nonatomic)BOOL isRemoved;
@property (nonatomic)BOOL inPile;
@end
