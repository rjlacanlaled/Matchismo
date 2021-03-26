//
//  SetCardMatchingGameViewController.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/11/21.
//

#import "SetCardMatchingGameViewController.h"
#import "SetCardDeck.h"

@implementation SetCardMatchingGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.game.matchMode = 3;
    self.cardsInPlayCount = 12;
    self.cardsInPlayTotal = self.cardsInPlayCount;
    [self drawCardViews];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

@end
