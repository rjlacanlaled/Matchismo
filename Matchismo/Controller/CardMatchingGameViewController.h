//
//  CardMatchingGameViewController.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/11/21.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardMatchingGameViewController : UIViewController

@property (strong, nonatomic)CardMatchingGame *game;
@property (nonatomic) NSInteger cardsInPlayCount;
@property (nonatomic)NSInteger cardsInPlayTotal;

- (void)drawCardViews;
- (Deck *)createDeck; //abstract
+ (NSString *)defaultFont;
+ (float)defaultFontSize;
+ (NSAttributedString *)applyDefaultAttributesToString: (NSString *)str;

@end

