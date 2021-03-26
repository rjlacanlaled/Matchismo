//
//  PlayingCard.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "PlayingCard.h"

@implementation PlayingCard

#pragma mark - Getters/Setters

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

#pragma mark - Method implementation

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    if ([otherCards count] > 0) {
        for (PlayingCard *otherCard in otherCards) {
            if (otherCard.rank == self.rank) {
                score += 4;
            } else if([otherCard.suit isEqualToString:self.suit]) {
                score +=1;
            }
        }
    }
    return score;
}

#pragma mark - Helper methods


+ (NSArray *)validSuits
{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count]-1;
}

@end
