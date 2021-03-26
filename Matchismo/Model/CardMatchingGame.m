//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by RJ Lacanlale on 12/5/20.
//  Copyright © 2020 Kooapps. All rights reserved.
//

#import "CardMatchingGame.h"
#import "SetCard.h"
#import "PlayingCard.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic)NSInteger score;
@property (strong, nonatomic)NSMutableArray *chosenCards; // of Card
@property (strong, nonatomic)NSMutableDictionary *scoreDetails;
@property (strong, nonatomic)NSDate *gameStartTime;
@property (strong, nonatomic)NSMutableArray *highScores;
@end

@implementation CardMatchingGame

#pragma mark - Initializers

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        self.gameStartTime = [[NSDate alloc] init];
        for (int i = 0; i < count; i++) {
        Card *card = [deck drawRandomCard];
            if(card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

#pragma mark - Getters/Setters

@synthesize matchMode = _matchMode;

- (NSUInteger)matchMode {
    if (!_matchMode) {
        _matchMode = 2;
    }
    return _matchMode;
}

- (void)setMatchMode:(NSUInteger)matchMode {
    if (matchMode > 1) {
        _matchMode = matchMode;
    } else {
        _matchMode = 2;
    }
}

- (NSMutableArray *)highScores {
    if (!_highScores) {
        _highScores = [[NSMutableArray alloc] init];
    }
    return _highScores;
}

- (NSMutableDictionary *)scoreDetails {
    if (!_scoreDetails) {
        _scoreDetails = [[NSMutableDictionary alloc] init];
    }
    return _scoreDetails;
}
- (NSMutableArray *)pickedCardsIndices {
    if (!_pickedCardsIndices) {
        _pickedCardsIndices = [[NSMutableArray alloc] init];
    }
    return _pickedCardsIndices;
}

- (NSInteger)unmatchedCardsCount {
    if (!_unmatchedCardsCount) {
        _unmatchedCardsCount = [self.cards count];
    }
    return _unmatchedCardsCount;
}

- (NSString *)currentMove {
    if (!_currentMove) {
        _currentMove = [[NSString alloc] init];
    }
    return _currentMove;
}

- (NSMutableArray *)chosenCards {
    if (!_chosenCards) {
        _chosenCards = [[NSMutableArray alloc] init];
    }
    return _chosenCards;
}

- (NSMutableArray *)cards {
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

static const int DEFAULT_MATCH_POINT = 1;
static const int DEFAULT_MISMATCH_PENALTY = 1;
static const int DEFAULT_MATCH_BONUS = 4;
static const int DEFAULT_COST_TO_CHOOSE = 1;
static const int DEFAULT_MAX_PLAYING_CARD = 30;
static const int DEFAULT_MAX_SET_CARD = 12;
static const int DEFAULT_ADD_CARD_PENALTY = 30.0;

+ (NSUInteger)matchPoint {
    NSUInteger matchPoint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"matchPoint"] intValue];
    
    if (!matchPoint) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:DEFAULT_MATCH_POINT] forKey:@"matchPoint"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"matchPoint"] intValue];
}

+ (NSUInteger)pointMultiplier {
    NSUInteger pointMultiplier = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pointMultiplier"] intValue];
    
    if (!pointMultiplier) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:DEFAULT_MATCH_BONUS] forKey:@"pointMultiplier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"pointMultiplier"] intValue];
}

+ (NSUInteger)costToChoose {
    NSUInteger costToChoose = [[[NSUserDefaults standardUserDefaults] objectForKey:@"costToChoose"] intValue];
    
    if (!costToChoose) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:DEFAULT_COST_TO_CHOOSE] forKey:@"costToChoose"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"costToChoose"] intValue];
}

+ (NSUInteger)mismatchPenalty {
    NSUInteger mismatchPenalty = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mismatchPenalty"] intValue];
    
    if (!mismatchPenalty) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:DEFAULT_MISMATCH_PENALTY] forKey:@"mismatchPenalty"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"mismatchPenalty"] intValue];
}

+ (void)setMatchPoint:(NSUInteger)matchPoint {
    if (matchPoint > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)matchPoint] forKey:@"matchPoint"];
    }
}

+ (NSUInteger)maxPlayingCard {
    NSUInteger maxPlayingCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxPlayingCard"] intValue];
    
    if (!maxPlayingCard) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:DEFAULT_MAX_PLAYING_CARD] forKey:@"maxPlayingCard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxPlayingCard"] intValue];
}

+ (void)setMaxPlayingCard:(NSUInteger)maxPlayingCard {
    if (maxPlayingCard > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)maxPlayingCard] forKey:@"maxPlayingCard"];
    }
}

+ (NSUInteger)maxSetCard {
    NSUInteger maxSetCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxSetCard"] intValue];
    
    if (!maxSetCard) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:DEFAULT_MAX_SET_CARD] forKey:@"maxSetCard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxSetCard"] intValue];
}

+ (void)setMaxSetCard:(NSUInteger)maxSetCard {
    if (maxSetCard > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)maxSetCard] forKey:@"maxSetCard"];
    }
}

+ (void)setPointMultiplier:(NSUInteger)pointMultiplier {
    
    if (pointMultiplier > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)pointMultiplier] forKey:@"pointMultiplier"];
    }
}

+ (void)setCostToChoose:(NSUInteger)costToChoose {
    if (costToChoose >= 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)costToChoose] forKey:@"costToChoose"];
    }
}

+ (void)setMismatchPenalty:(NSUInteger)mismatchPenalty {
    if (mismatchPenalty >= 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)mismatchPenalty] forKey:@"mismatchPenalty"];
    }
}


#pragma mark - Method implementation

- (Card *)cardAtIndex:(NSUInteger)index {
    if (index < [self.cards count]) {
        return self.cards[index];
    } else {
        return nil;
    }
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    
    if (![self isGameOver]) {
        int matchScore = 0;
        if ([self hasPossibleMatch: self.cards]) {
            Card *card = [self cardAtIndex:index];
            [self toggleCard:card];
            
            if ([self.chosenCards count] >= self.matchMode) {
                matchScore = [self calculateMatchScore];
            }
        }
        
        [self logCurrentMove:matchScore];
        
        if ([self isGameOver]) {
            [self revealCards];
            [self logScoreDetails];
        }
        
        // reset chosen cards if enough cards have been picked
        if ([self.chosenCards count] >= self.matchMode) {
            [self.chosenCards removeAllObjects];
        }
    }
}

#pragma mark - Helper methods

- (void)updateCurrentChosenCardsIndices{
    [self.pickedCardsIndices removeAllObjects];
    if([self.chosenCards count] <= self.matchMode) {
        for (Card *card in self.chosenCards) {
            if (card) {
                NSUInteger index = [self.cards indexOfObject:card];
                [self.pickedCardsIndices addObject:[NSNumber numberWithLong:index]];
            }
        }
    }
}

- (BOOL)hasPossibleMatch: (NSArray *)cardsToCheck {

    if ([cardsToCheck count] >= self.matchMode) {
        for (int i = 0; i < [cardsToCheck count] - (self.matchMode - 1); i++) {
            if (![cardsToCheck[i] isMatched]) {
                NSMutableArray *cardsToCompare = [[NSMutableArray alloc] init];
                int secondObjectIndex = 0;
                for (int j = i + 1; j < [cardsToCheck count]; j++) {
                    if ([cardsToCompare count] < self.matchMode) {
                        if (![cardsToCheck[j] isMatched]) {
                            [cardsToCompare addObject:self.cards[j]];
                        }
                    }
                    if (self.matchMode > 2 && [cardsToCompare count] == 2) {
                        secondObjectIndex = j;
                    }
                    if ([cardsToCompare count] == self.matchMode - 1) {

                        int score = [cardsToCheck[i] match:cardsToCompare];
                        if ( score > 0 ) {
                            return YES;
                        }
                        [cardsToCompare removeAllObjects];
                        if (self.matchMode > 2) {
                            j = secondObjectIndex - 1;
                            secondObjectIndex = 0;
                        }
                    }
                }
            }
        }
    }
    
    return NO;
}

- (void)logCurrentMove: (NSInteger)matchScore {
    self.currentMove = @"";
    [self updateCurrentChosenCardsIndices];
    
    if (matchScore > 0) {
        self.currentMove = [self.currentMove stringByAppendingString:
                        [NSString stringWithFormat:
                        @" matched for %ld point(s).",
                        matchScore
                        ]];
    } else if (matchScore < 0){
        self.currentMove = [self.currentMove stringByAppendingString:
                        [NSString stringWithFormat:
                        @" do not match. %d point(s) penalty!",
                        (int)CardMatchingGame.mismatchPenalty
                        ]];
    } else if ([self hasPossibleMatch: self.cards]){
        if ([self.pickedCardsIndices count] > 0) {
            self.currentMove = @" picked.";
        } else {
            self.currentMove = @"";
        }
    }

    if ([self areAllMatched]) {
        self.currentMove = [self.currentMove stringByAppendingString:
                            @"Congratulations, you have matched all the cards!"];
    } else if (![self hasPossibleMatch: self.cards]) {
        self.currentMove = [self.currentMove stringByAppendingString:@"There are no more possible matches. Game over!"];
    }
}



- (BOOL)areAllMatched {
    for (Card *card in self.cards) {
        if (!card.isMatched) {
            return NO;
        }
    }
    return YES;
}

- (void)toggleCard: (Card *)card {
    if(!card.isChosen) {
        card.chosen = YES;
        [self.chosenCards addObject:card];
        int costToChoose = 0 - CardMatchingGame.costToChoose;
        [self updateScore:costToChoose];
    } else {
        card.chosen = NO;
        [self.chosenCards removeObject:card];
    }
}

- (int)calculateMatchScore {
    int matchScore = 0;
    for (int i = 0; i < self.matchMode - 1; i++) {
        NSMutableArray *otherCards =
            [[NSMutableArray alloc] init];
        Card *cardToMatch = self.chosenCards[i];
        for (int j = i + 1; j < self.matchMode; j++) {
            [otherCards addObject:self.chosenCards[j]];
        }
        if ([otherCards count] > 0) {
                matchScore += [cardToMatch match:otherCards];
        }
    }
    
    matchScore *= CardMatchingGame.matchPoint;
    
    if(matchScore > 0) {
        matchScore *=  (CardMatchingGame.pointMultiplier);
        [self updateScore:matchScore];
        for (Card *card in self.chosenCards) {
            card.matched = YES;
        }
        self.unmatchedCardsCount -= self.matchMode;
    } else {
        matchScore = 0 - (int)CardMatchingGame.mismatchPenalty;
        [self updateScore:matchScore];
        for (int i = 0; i < self.matchMode; i++) {
            if(i < self.matchMode) {
                Card *card = self.chosenCards[i];
                card.chosen = NO;
            }
        }
    }
    
    return matchScore;
}

- (void)revealCards {
    for (Card *card in self.cards) {
        if (!card.isChosen) {
            card.chosen = YES;
        }
    }
}

static const int LOWEST_SCORE = -50000;
static const int MAX_SCORE = 50000;

- (void)updateScore: (int)score {
    self.score += score;
    
    if (self.score < LOWEST_SCORE) {
        self.score = LOWEST_SCORE;
    }
    
    if (self.score > MAX_SCORE) {
        self.score = MAX_SCORE;
    }
    
}

- (void)logScoreDetails {
    
    [self updateScoreDetails];
    
    if (self.score > 0) {
        NSMutableArray *highScores = [(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"highScores"] mutableCopy];
        
        if (highScores) {
            [highScores addObject:self.scoreDetails];
            [[NSUserDefaults standardUserDefaults] setObject:highScores forKey:@"highScores"];
        } else {
            [self.highScores addObject:self.scoreDetails];
            [[NSUserDefaults standardUserDefaults] setObject:self.highScores forKey:@"highScores"];
        }
    }
}

- (void)updateScoreDetails {
    [self.scoreDetails setObject:[[NSNumber alloc] initWithLong:self.score] forKey:@"score"];
    [self.scoreDetails setObject:[self getCurrentDateTime] forKey:@"time"];
    [self.scoreDetails setObject:[[NSNumber alloc] initWithDouble:[self getGameDuration]] forKey:@"duration"];
    [self.scoreDetails setObject:[self getGameType] forKey:@"gameType"];
}

- (NSString *)getGameType {
    NSString *gameType = @"";
    if ([[self.cards firstObject] isKindOfClass:[SetCard class]]) {
        gameType = @"Set";
    } else if ([[self.cards firstObject] isKindOfClass:[PlayingCard class]]) {
        gameType = @"PlayingCard";
    }
    return gameType;
}

- (NSDate *)getCurrentDateTime {
    return [NSDate date];
}

- (BOOL)isGameOver {
    if(![self hasPossibleMatch: self.cards] || [self areAllMatched]) {
        return YES;
    }
    return NO;
}

- (NSTimeInterval)getGameDuration {
    return [[NSDate date] timeIntervalSinceDate:self.gameStartTime];
}

- (NSArray *)getHighScoresForGame: (NSString *)gameType {
    NSMutableArray *filteredHighScores = [[NSMutableArray alloc] init];
    NSMutableArray *highScores = [[self getArrayFromStandardUserDefaultsWithCategory:@"highScores"] mutableCopy];
    
    if (![gameType isEqualToString:@"All"]) {
        for (NSDictionary *highScore in highScores) {
            if ([[highScore objectForKey:@"gameType"] isEqualToString:gameType]) {
                [filteredHighScores addObject:highScore];
            }
        }
    } else {
        filteredHighScores = highScores;
    }
    
    return filteredHighScores;
}

- (NSArray *)getArrayFromStandardUserDefaultsWithCategory:(NSString *)aCategory {
    return [[NSUserDefaults standardUserDefaults] objectForKey:aCategory];
}

- (NSArray *)sortArrayByCategory:(NSString *)aCategory
                      array:(NSArray *)anArray
                isAscending:(BOOL)isAscending {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:aCategory ascending:isAscending];
    return [anArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)firstCardMatchInCardArray: (NSArray *)cardsToCheck {
    if ([cardsToCheck count] >= self.matchMode) {
        for (int i = 0; i < [cardsToCheck count] - (self.matchMode - 1); i++) {

            if (![cardsToCheck[i] isMatched]) {
                NSMutableArray *cardsToCompare = [[NSMutableArray alloc] init];
                int secondObjectIndex = 0;
                for (int j = i + 1; j < [cardsToCheck count]; j++) {
                    if ([cardsToCompare count] < self.matchMode) {
                        if (![cardsToCheck[j] isMatched]) {
                            [cardsToCompare addObject:self.cards[j]];
                        }
                    }
                    
                    if (self.matchMode > 2 && [cardsToCompare count] == 2) {
                        secondObjectIndex = j;
                    }
                    if ([cardsToCompare count] == self.matchMode - 1) {

                        int score = [cardsToCheck[i] match:cardsToCompare];
                        if ( score > 0 ) {
                            [cardsToCompare addObject:cardsToCheck[i]];
                            return cardsToCompare;
                        }
                        [cardsToCompare removeAllObjects];
                        if (self.matchMode > 2) {
                            j = secondObjectIndex - 1;
                            secondObjectIndex = 0;
                        }
                    }
                }
            }
        }
    }
    
    return nil;
}

- (void)addCardPenalty: (NSArray *)cards {
    if ([self hasPossibleMatch:cards]) {
        self.score -= DEFAULT_ADD_CARD_PENALTY;
    }
}

@end
