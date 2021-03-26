//
//  SetCardView.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "SetCardView.h"

@interface SetCardView ()
@property (nonatomic) CGRect tempSubRect;
@property (strong, nonatomic) UIColor *normalColor;

@end

@implementation SetCardView


#pragma mark - Properties


@synthesize normalColor = _normalColor;

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor whiteColor];
    }
    return _normalColor;
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self setNeedsDisplay];
}

@synthesize shape = _shape;

- (Shape *)shape {
    if (!_shape) {
        _shape = [[Shape alloc] init];
    }
    return _shape;
}

- (void)setShape:(Shape *)shape {
    _shape = shape;
    [self setNeedsDisplay];
}

@synthesize color = _color;

- (void)setColor:(Color *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (Color *)color {
    if (!_color) {
        _color = [[Color alloc] init];
    }
    return _color;
}

@ synthesize shade = _shade;

- (void)setShade:(Shade *)shade {
    _shade = shade;
    [self setNeedsDisplay];
}

- (Shade *)shade {
    if (!_shade) {
        _shade = [[Shade alloc] init];
    }
    return _shade;
}

- (void)setNumberOfShapes:(NSInteger)numberOfShapes {
    _numberOfShapes = numberOfShapes;
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

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#define CORNER_RADIUS 0.12
#define SCALE_FACTOR 0.90
#define DEFAULT_SUB_RECT_COUNT 3.0

- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor = [UIColor clearColor];
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS * self.bounds.size.width];
    [roundedRect addClip];
    
    
    [self.normalColor setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawCard];
    
}

#define DEFAULT_STROKE_WIDTH 0.04

- (void)drawCard {
    CGRect setCardContentRect = [self contentRectWithSubRect:self.numberOfShapes];
    for (int i = 0; i < self.numberOfShapes; i++) {
        self.tempSubRect = [self contentRectForSubRect: (i + 1)
                                       forParentRect:setCardContentRect
                                    withSubRectCount:self.numberOfShapes];
        UIBezierPath *shape = [self drawShape];
        
        [self setStrokeForPath:shape withStrokeColor:self.color];
        [self setStrokeWidthForPath:shape withStrokeWidth:DEFAULT_STROKE_WIDTH * shape.bounds.size.width];
        
        if (self.shade.isFilled) {
            [self fillPath:shape withColor:self.color];
        }
        
        if (self.shade.isStriped) {
            [self fillPathWithStripes:shape withColor:self.color];
        }
    }
    
    if (self.isChosen) {
        self.alpha = 0.3;
    } else {
        self.alpha = 1.0;
    }
    
}

- (UIBezierPath *)drawShape {
    SEL drawSpecificShape = NSSelectorFromString([NSString stringWithFormat:
                                                  @"draw%@",
                                                  self.shape.name
                                                  ]);
    if (drawSpecificShape) {
        return [self performSelector:drawSpecificShape];
    }
    
    return nil;
}

- (void)setStrokeForPath: (UIBezierPath *)aPath withStrokeColor: (Color *)aColor {
    [[UIColor colorWithRed:aColor.red green:aColor.green blue:aColor.blue alpha:1.0] setStroke];
    [aPath stroke];
}

- (void)setStrokeWidthForPath: (UIBezierPath *)aPath withStrokeWidth: (float)strokeWidthSize {
    aPath.lineWidth = strokeWidthSize;
    [aPath stroke];
}

#define DEFAULT_PATTERN_DISTANCE 25.0
#define DEFAULT_STRIPE_WIDTH 0.001
- (void)fillPathWithStripes: (UIBezierPath *)aPath withColor: (Color *)aColor{
    CGRect bounds = aPath.bounds;
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    [aPath addClip];
    UIBezierPath *verticalLine = [UIBezierPath bezierPath];
    for (float x = 0; x < aPath.bounds.size.width; x += (aPath.bounds.size.width) / DEFAULT_PATTERN_DISTANCE) {
        [verticalLine moveToPoint:CGPointMake(bounds.origin.x + x,
                                              bounds.origin.y)];
        [verticalLine addLineToPoint:CGPointMake(bounds.origin.x + x,
                                                 bounds.origin.y + bounds.size.height)];
        [self setStrokeWidthForPath:verticalLine withStrokeWidth:(bounds.size.height + bounds.size.width) * DEFAULT_STRIPE_WIDTH];
        [self setStrokeForPath:verticalLine withStrokeColor:aColor];
    }
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)fillPath: (UIBezierPath *)aPath withColor: (Color *)aColor {
    [[UIColor colorWithRed:aColor.red green:aColor.green blue:aColor.blue alpha:1.0] setFill];
    [aPath fill];
}

#pragma mark - Draw Shapes

- (UIBezierPath *)drawSquiggle {
    
    CGRect aRect = self.tempSubRect;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(aRect.origin.x + aRect.size.width*0.05, aRect.origin.y + aRect.size.height*0.40)];

    [path addCurveToPoint:CGPointMake(aRect.origin.x + aRect.size.width*0.35, aRect.origin.y + aRect.size.height*0.25)
                controlPoint1:CGPointMake(aRect.origin.x + aRect.size.width*0.09, aRect.origin.y + aRect.size.height*0.15)
                controlPoint2:CGPointMake(aRect.origin.x + aRect.size.width*0.18, aRect.origin.y + aRect.size.height*0.10)];

    [path addCurveToPoint:CGPointMake(aRect.origin.x + aRect.size.width*0.75, aRect.origin.y + aRect.size.height*0.30)
                controlPoint1:CGPointMake(aRect.origin.x + aRect.size.width*0.40, aRect.origin.y + aRect.size.height*0.30)
                controlPoint2:CGPointMake(aRect.origin.x + aRect.size.width*0.60, aRect.origin.y + aRect.size.height*0.45)];

    [path addCurveToPoint:CGPointMake(aRect.origin.x + aRect.size.width*0.97, aRect.origin.y + aRect.size.height*0.35)
                controlPoint1:CGPointMake(aRect.origin.x + aRect.size.width*0.87, aRect.origin.y + aRect.size.height*0.15)
                controlPoint2:CGPointMake(aRect.origin.x + aRect.size.width*0.98, aRect.origin.y + aRect.size.height*0.00)];

    [path addCurveToPoint:CGPointMake(aRect.origin.x + aRect.size.width*0.45, aRect.origin.y + aRect.size.height*0.85)
                controlPoint1:CGPointMake(aRect.origin.x + aRect.size.width*0.95, aRect.origin.y + aRect.size.height*1.10)
                controlPoint2:CGPointMake(aRect.origin.x + aRect.size.width*0.50, aRect.origin.y + aRect.size.height*0.95)];

    [path addCurveToPoint:CGPointMake(aRect.origin.x + aRect.size.width*0.25, aRect.origin.y + aRect.size.height*0.85)
                controlPoint1:CGPointMake(aRect.origin.x + aRect.size.width*0.40, aRect.origin.y + aRect.size.height*0.80)
                controlPoint2:CGPointMake(aRect.origin.x + aRect.size.width*0.35, aRect.origin.y + aRect.size.height*0.75)];

    [path addCurveToPoint:CGPointMake(aRect.origin.x + aRect.size.width*0.05, aRect.origin.y + aRect.size.height*0.40)
                controlPoint1:CGPointMake(aRect.origin.x + aRect.size.width*0.00, aRect.origin.y + aRect.size.height*1.10)
                controlPoint2:CGPointMake(aRect.origin.x + aRect.size.width*0.005, aRect.origin.y + aRect.size.height*0.60)];

    return path;
}

- (UIBezierPath *)drawOval  {
    
    return [UIBezierPath bezierPathWithOvalInRect:self.tempSubRect];
}


- (UIBezierPath *)drawDiamond{
    
    CGRect aRect = self.tempSubRect;

    CGPoint upperMiddle = CGPointMake(CGRectGetMidX(aRect), aRect.origin.y);
    CGPoint lowerMiddle = CGPointMake(CGRectGetMidX(aRect), CGRectGetMaxY(aRect));
    CGPoint leftMiddle = CGPointMake(aRect.origin.x, CGRectGetMidY(aRect));
    CGPoint rightMiddle = CGPointMake(CGRectGetMaxX(aRect), CGRectGetMidY(aRect));
        
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:upperMiddle];
    [path addLineToPoint:rightMiddle];
    [path addLineToPoint:lowerMiddle];
    [path addLineToPoint:leftMiddle];
    [path addLineToPoint:upperMiddle];
    
    return path;
}


#pragma mark - Helper Methods

- (void)moveRectToCenterOfMainView: (CGRect)aRect {
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), self.bounds.origin.x,
                          (CGRectGetMaxY(self.bounds) - CGRectGetMaxY(aRect)) / 2);
}

- (CGRect)contentRectWithSubRect: (NSInteger)subRectCount{

    CGRect mainRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, (self.bounds.size.height / DEFAULT_SUB_RECT_COUNT) * subRectCount);
    
    [self moveRectToCenterOfMainView:mainRect];
    
    return mainRect;
}

#define SCALE_FACTOR_Y 8.0
#define SCALE_FACTOR_X 4.0

- (CGRect)contentRectForSubRect: (NSInteger)rectNumber
                     forParentRect:(CGRect)parentRect
                  withSubRectCount: (NSInteger)subRectCount {
    
    CGRect subRect = CGRectMake(parentRect.origin.x,
                                       (CGRectGetMaxY(parentRect)/subRectCount) * (rectNumber - 1),
                                       parentRect.size.width,
                                       parentRect.size.height / subRectCount);
    
    UIEdgeInsets insets =
    UIEdgeInsetsMake(subRect.size.height / SCALE_FACTOR_Y,
                     subRect.size.height / SCALE_FACTOR_X,
                     subRect.size.height / SCALE_FACTOR_Y,
                     subRect.size.height / SCALE_FACTOR_X);
    
    subRect = UIEdgeInsetsInsetRect(subRect, insets);
    
    return subRect;
    
}

- (void)cardChosenAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isChosen) {
            self.alpha = 1.0;
        } else {
            self.alpha = 0.3;
        }
    } completion:^(BOOL finished){}];
}

- (void)cardMatchAnimation {
    [UIView animateWithDuration:0.5
                     animations:^{
        self.alpha = 0.0;
    }
                     completion:^(BOOL finished){
        [self removeFromSuperview];
        
    }];
    
    
}

- (void)cardDealAnimationToRect: (CGRect)rect {
    [UIView animateWithDuration:1.0 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        [self setFrame:rect];
        [self setNeedsDisplay];
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

- (void)cardSpringAnimation: (BOOL)isSuccess {
    CGPoint originalCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionAutoreverse animations:^{
        self.center = CGPointMake(CGRectGetMidX(self.frame), self.frame.origin.y * 0.99);
        if (isSuccess) {
            self.normalColor = [UIColor yellowColor];
            
        } else {
            self.normalColor = [UIColor systemOrangeColor];
        }
    } completion: ^(BOOL finished){
        
        [UIView animateWithDuration:0.5 animations:^{
            self.normalColor = [UIColor whiteColor];
            self.center = originalCenter;
        }];
        
    }];
    
   
}


@end
