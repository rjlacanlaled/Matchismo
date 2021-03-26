//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by RJ Lacanlale on 12/5/20.
//  Copyright © 2020 Kooapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount: (NSUInteger)count
                        usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (BOOL)isGameOver;

// Filters
- (NSArray *)getArrayFromStandardUserDefaultsWithCategory: (NSString *)aCategory;
- (NSArray *)getHighScoresForGame: (NSString *)gameType;
- (NSArray *)sortArrayByCategory: (NSString *)aCategory
                           array:(NSArray *)anArray
                     isAscending:(BOOL)isAscending;
- (NSArray *)firstCardMatchInCardArray: (NSArray *)cardsToCheck;
- (void)addCardPenalty: (NSArray *)cards;

@property (readonly, nonatomic)NSInteger score;
@property (nonatomic)NSUInteger matchMode;
@property (strong, nonatomic)NSString *currentMove;
@property (strong, nonatomic)NSMutableArray *pickedCardsIndices;
@property (strong, nonatomic)NSMutableArray *cards;

@property (class, nonatomic)NSUInteger matchPoint;
@property (class, nonatomic)NSUInteger pointMultiplier;
@property (class, nonatomic)NSUInteger costToChoose;
@property (class, nonatomic)NSUInteger mismatchPenalty;
@property (class, nonatomic)NSUInteger maxPlayingCard;
@property (class, nonatomic)NSUInteger maxSetCard;

@property (nonatomic)NSInteger unmatchedCardsCount;
@property (nonatomic)NSInteger cardsInPlayCount;
@property (nonatomic)NSInteger maxCardInPlay;
@property (nonatomic)NSInteger totalCard;
@end
