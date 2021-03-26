//
//  PlayingCardView.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

- (void)cardFlipAnimation;
- (void)cardMatchAnimation;
- (void)cardDealAnimationToRect: (CGRect)rect;
- (void)cardDisappearAnimation;

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic)BOOL isChosen;
@property (nonatomic)BOOL isMatched;
@property (nonatomic)BOOL isAnimating;
@property (nonatomic)BOOL inPile;
@end

    
