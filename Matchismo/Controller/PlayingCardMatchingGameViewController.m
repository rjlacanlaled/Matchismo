//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/11/21.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@implementation PlayingCardMatchingGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
