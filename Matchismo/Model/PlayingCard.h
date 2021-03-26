//
//  PlayingCard.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
