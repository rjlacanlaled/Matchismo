//
//  SetCardDeck.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *colors = [SetCard validColors];
        NSArray *shapes = [SetCard validShapes];
        NSArray *shades = [SetCard validShades];
        
        for (int i = 1; i <= [SetCard maxNumberOfShape]; i++) {
            for (int c = 0; c < [colors count]; c++) {
                for (int sp = 0; sp < [shapes count]; sp++) {
                    for (int sd = 0; sd < [shades count]; sd++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.numberOfShape = i;
                        card.color = colors[c];
                        card.shape = shapes[sp];
                        card.shade = shades[sd];
                        [self addCard:card];
                    }
                }
            }
        }

    }
    return self;
}

@end
