//
//  PlayingCardView.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView


#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)faceCardScaleFactor {
    if (!_faceCardScaleFactor) {
        _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    }
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setIsChosen:(BOOL)isChosen {
    _isChosen = isChosen;
    [self setNeedsDisplay];
}

- (void)setIsMatched:(BOOL)isMatched {
    _isMatched = isMatched;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor {
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
    return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
    return [self cornerRadius] / 3.0;
}


- (void)drawRect:(CGRect)rect {
    [self setExclusiveTouch:YES];
    [self drawCard];
}

- (UIView *)drawCardFront {
    [self drawRoundedCardRect];
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat: @"%@%@", [self rankAsString], self.suit]];
    if (faceImage) {
        [self drawCardImage: faceImage inRect:[self rectForFaceImage]];
    } else {
        [self drawPips];
    }
    [self drawCorners];
    return self;
}

- (UIView *)drawCardBack {
    [self drawRoundedCardRect];
    [self drawCardImage: [UIImage imageNamed:@"cardback"] inRect:self.bounds];
    return self;
}

- (void)drawCard {
    if (self.isChosen) {
        [self drawCardFront];
    } else {
        [self drawCardBack];
    }
}

- (CGRect)rectForFaceImage {
    return CGRectInset(self.bounds,
                self.bounds.size.width *
                (1.0 - self.faceCardScaleFactor),
                self.bounds.size.height *
                (1.0 - self.faceCardScaleFactor));
}

- (void)drawCardImage: (UIImage *)cardImage inRect: (CGRect)rect {
    [cardImage drawInRect:rect];
}

- (void)drawRoundedCardRect {
    self.superview.backgroundColor = nil;
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

- (NSArray *)rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (void)drawPips {

}


- (void)drawCorners {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerString = [[NSAttributedString alloc]
                                        initWithString:[NSString stringWithFormat:
                                                        @"%@\n%@",
                                                        [self rankAsString],
                                                        self.suit]
                                        attributes:@{NSFontAttributeName: cornerFont, NSParagraphStyleAttributeName: paragraphStyle}];
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerString size];
    [cornerString drawInRect:textBounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);

    [cornerString drawInRect:textBounds];
}

- (void)animateCardMatch {
    [UIView animateWithDuration:1.0
                     animations:^{self.alpha = 0.0; self.isAnimating = YES;}
                     completion:^(BOOL finished){ [self removeFromSuperview];}];
    self.isAnimating = NO;
}

- (void)cardFlipAnimation {
    
    UIViewAnimationOptions cardFlipOption;
    
    if (self.isChosen) {
        cardFlipOption = UIViewAnimationOptionTransitionFlipFromLeft;
    } else {
        cardFlipOption = UIViewAnimationOptionTransitionFlipFromRight;
    }
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:cardFlipOption
                    animations:^{
        if (self.isChosen) {
            [self drawCardFront];
        } else {
            [self drawCardBack];
        }
    }
                    completion:^(BOOL finished){}];
    
}

- (void)cardMatchAnimation {
    [self setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 delay: 0.5 options: UIViewAnimationOptionTransitionNone animations:^{
        self.alpha = 0.3;
    } completion:^(BOOL finished){}];
}

- (void)cardDealAnimationToRect: (CGRect)rect {
   
    [UIView animateWithDuration:1.0 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        [self setFrame: rect];
    } completion:^(BOOL finished){}];
    
}

- (void)cardDisappearAnimation {
    self.alpha = 1.0;
    [UIView animateWithDuration:10.0 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
