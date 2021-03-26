//
//  SetCard.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "SetCard.h"

@implementation SetCard

#pragma mark - Getters/Setters


- (void)setNumberOfShapes:(NSUInteger)numberOfShape {
    _numberOfShape = numberOfShape;

}

@synthesize shape = _shape;

- (void)setShape:(Shape *)shape {
    _shape = shape;

}

- (Shape *)shape {
    if (!_shape) {
        _shape = [[Shape alloc] init];
    }
    return _shape;
}

@synthesize shade = _shade;

- (Shade *)shade {
    if (!_shade) {
    _shade = [[Shade alloc] init];
    }
    return _shade;
}

- (void)setShade:(Shade *)shade {
    _shade = shade;
}

@synthesize color = _color;

- (Color *)color {
    if (!_color) {
        _color = [[Color alloc] init];
    }
    return _color;
}

- (void)setColor:(Color *)color {
    _color = color;
}

#pragma mark - Method implementation

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    if([otherCards count] == 2) {
        SetCard *otherCard1 = otherCards[0];
        SetCard *otherCard2 = otherCards[1];
        
        NSArray *numberOfShapes = @[
            [NSNumber numberWithInteger:self.numberOfShape],
            [NSNumber numberWithInteger:otherCard1.numberOfShape],
            [NSNumber numberWithInteger:otherCard2.numberOfShape]
        ];
        
        NSArray<Color*> *colors = @[
            self.color,
            otherCard1.color,
            otherCard2.color
        ];
        
        NSArray<Shape*> *shapes = @[
            self.shape,
            otherCard1.shape,
            otherCard2.shape
        ];
        
        NSArray<Shade*> *shades = @[
            self.shade,
            otherCard1.shade,
            otherCard2.shade
        ];
        
        
        if (![SetCard allSameOrDifferentProperty:numberOfShapes]) {
            score -= 1;
        }
        
        if (![SetCard allSameOrDifferentProperty:colors]) {
            score -= 10;
        }
        
        if (![SetCard allSameOrDifferentProperty:shapes]) {
            score -= 100;
        }
        
        if (![SetCard allSameOrDifferentProperty:shades]) {
            score -= 1000;
        }
        
        if (score >= 0) {
            score = 3;
        }
    }

    return score;
}

+ (BOOL)allSameOrDifferentProperty: (NSArray *)propertyOfCards {
    
    if ([propertyOfCards[0] isEqual:propertyOfCards[1]]) {
        if ([propertyOfCards[1] isEqual:propertyOfCards[2]]) {
            return YES;
        }
    } else if (![propertyOfCards[0] isEqual:propertyOfCards[2]] &&
            ![propertyOfCards[1] isEqual:propertyOfCards[2]]) {
            return YES;
    }
    return NO;
}

+ (BOOL)isSetCard: (Card *)card {
    if ([card isKindOfClass:[SetCard class]]) {
        return YES;
    }
    return NO;
}

const int MAX_NUMBER_OF_SHAPE = 3;

+ (NSUInteger)maxNumberOfShape {
    return MAX_NUMBER_OF_SHAPE;
}

+ (NSArray *)validShapes {
    
    Shape *shape1 = [[Shape alloc] initWithName:@"Diamond"];
    Shape *shape2 = [[Shape alloc] initWithName:@"Squiggle"];
    Shape *shape3 = [[Shape alloc] initWithName:@"Oval"];
    
    return @[shape1, shape2, shape3];
}

+ (NSArray *)validShades {
    
    Shade *shade1 = [[Shade alloc] initWithName:@"solid" alpha:1.0 isFilled:YES isStriped:NO];
    Shade *shade2 = [[Shade alloc] initWithName:@"striped" alpha:1.0 isFilled:NO isStriped:YES];
    Shade *shade3 = [[Shade alloc] initWithName:@"open" alpha:1.0 isFilled:NO isStriped:NO];
    
    return @[shade1, shade2, shade3];
}

+ (NSArray *)validColors {
    
    Color *color1 = [[Color alloc] initWithName:@"red" red:255.0/255.0 green:0.0 blue:0.0];
    Color *color2 = [[Color alloc] initWithName:@"green" red:0.0 green:255.0/255.0 blue:0.0];
    Color *color3 = [[Color alloc] initWithName:@"purple" red:178.0/255.0 green:102.0/255.0 blue:255.0/255.0];
    
    return @[color1, color2, color3];
}

@end
