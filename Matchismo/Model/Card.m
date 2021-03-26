//
//  Card.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "Card.h"

@implementation Card

#pragma mark - Initializers

- (int)match: (NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

- (void)setChosen:(BOOL)chosen {
    _chosen = chosen;
}

- (void)setMatched:(BOOL)matched {
    _matched = matched;
}

@end
