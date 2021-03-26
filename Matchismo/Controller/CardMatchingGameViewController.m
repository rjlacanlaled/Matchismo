//
//  CardMatchingGameViewController.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/11/21.
//

#import "CardMatchingGameViewController.h"
#import "PlayingCardMatchingGameViewController.h"
#import "SetCardMatchingGameViewController.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "Grid.h"
#import "PlayingCard.h"
#import "SetCard.h"
#import "CardBounceBehavior.h"

@interface CardMatchingGameViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *cardAreaView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cardTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cardPileTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *cardPinchGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardPileView;
@property (weak, nonatomic) IBOutlet UIButton *cardHintButton;


@property (strong, nonatomic)Grid *cardGrid;
@property (strong, nonatomic)NSMutableArray *cardViewCollection;
@property (nonatomic)NSInteger totalCard;
@property (nonatomic) BOOL finishedDealing;
@property (strong, nonatomic) UIDynamicAnimator *bounceCardAnimator;
@property (strong, nonatomic) CardBounceBehavior *bounceCardBehavior;
@property (nonatomic)BOOL drawWithTransition;
@property (strong, nonatomic) NSMutableArray *cardGraveYard;
@end

@implementation CardMatchingGameViewController

#pragma mark - ViewController Life Cycle

- (void)viewDidLoad {
   [super viewDidLoad];
    self.cardPileTapGestureRecognizer.numberOfTapsRequired = 2;
    [self createCardSubViews];
    self.cardAreaView.backgroundColor = nil;
    self.cardPileView.alpha = 0.3;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification  object:nil];
}

#pragma mark - Properties

- (NSMutableArray *)cardGraveYard {
    if (!_cardGraveYard) {
        _cardGraveYard = [[NSMutableArray alloc] init];
    }
    return _cardGraveYard;
}

- (UIDynamicBehavior *)bounceCardBehavior {
    if (!_bounceCardBehavior) {
        _bounceCardBehavior = [[CardBounceBehavior alloc] init];
        [self.bounceCardAnimator addBehavior:_bounceCardBehavior];
    }
    return _bounceCardBehavior;
}

- (UIDynamicAnimator *)bounceCardAnimator {
    if (!_bounceCardAnimator) {
        _bounceCardAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _bounceCardAnimator.delegate = self;
    }
    return _bounceCardAnimator;
}

- (NSInteger)totalCard {
    if (!_totalCard) {
        _totalCard = self.game.totalCard;
    }
    return _totalCard;
}

- (NSMutableArray *)cardViewCollection {
    if (!_cardViewCollection) {
        _cardViewCollection = [[NSMutableArray alloc] init];
    }
    return _cardViewCollection;
}

- (CardMatchingGame *)game {
    if (!_game) {
        int total = 0;
        if ([self isKindOfClass:[PlayingCardMatchingGameViewController class]]) {
            total = (int)[CardMatchingGame maxPlayingCard];
            self.cardsInPlayCount = total;
        }
        
        if ([self isKindOfClass:[SetCardMatchingGameViewController class]]) {
            total = (int)[CardMatchingGame maxSetCard];
        }

        _game = [[CardMatchingGame alloc] initWithCardCount:total usingDeck:[self createDeck]];
        
        self.game.totalCard = total;
        self.totalCard = total;
        
    }
    return _game;
}


#pragma mark - Method Implementation

- (Deck *)createDeck {
    return nil;
}

#pragma mark - Event Handler
- (IBAction)tapCardGestureRecognizer:(UITapGestureRecognizer *)sender {
    UIView* view = self.cardTapGestureRecognizer.view;
    CGPoint loc = [self.cardTapGestureRecognizer locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    
    if ([subview isKindOfClass:[SetCardView class]] ||
        [subview isKindOfClass:[PlayingCardView class]]) {
    
        [self.game chooseCardAtIndex:subview.tag];
        [self updateCardViewCollectionValues];
        [self updateScoreLabel];
    }
    
    if ([self.game isGameOver]) {
        [self addBounceCardBehaviorToViews: self.cardAreaView.subviews];
        [self.cardTapGestureRecognizer setEnabled:NO];
    }
}

- (IBAction)tapPileGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    BOOL hasCardInPile = NO;
    
    if ([self isKindOfClass:[PlayingCardMatchingGameViewController class]]) {
        for (UIView *subview in self.cardViewCollection) {
            PlayingCardView *view = (PlayingCardView *)subview;
            if (view.inPile) {
                view.inPile = NO;
                hasCardInPile = YES;
            }
        }
    }
    
    if ([self isKindOfClass:[SetCardMatchingGameViewController class]]) {
        for (UIView *subview in self.cardViewCollection) {
            SetCardView *view = (SetCardView *)subview;
            if (view.inPile) {
                view.inPile = NO;
                hasCardInPile = YES;
            }
        }
    }
    
    if (hasCardInPile) {
        self.drawWithTransition = YES;
        [self drawCardViews];
        self.drawWithTransition = NO;
    }
}


- (IBAction)cardPinchGestureRecognizer:(UIPinchGestureRecognizer *)sender {
    UIView* view = self.cardPinchGestureRecognizer.view;
    CGPoint loc = [self.cardPinchGestureRecognizer locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    
    
    if ([subview isKindOfClass:[SetCardView class]] ||
        [subview isKindOfClass:[PlayingCardView class]]) {
        
        if ([subview isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *view = (PlayingCardView *)subview;
            view.inPile = YES;
            [view cardDealAnimationToRect:[self cardPileFrame]];
        }
        
        if ([subview isKindOfClass:[SetCardView class]]) {
            SetCardView *view = (SetCardView *)subview;
            view.inPile = YES;
            [view cardDealAnimationToRect:[self cardPileFrame]];
        }
        
    }

}

- (void)addBounceCardBehaviorToViews: (NSArray *)viewCollection {
    for (UIView *view in viewCollection) {
        [self.bounceCardBehavior addItem:view];
        if ([view isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *playingCardView = (PlayingCardView *)view;
            [playingCardView cardDisappearAnimation];
        }
        if ([view isKindOfClass:[SetCardView class]]) {
            
            SetCardView *setCardView = (SetCardView *)view;
            [setCardView cardDisappearAnimation];
        }
    }
}

- (void)orientationChanged: (NSNotification *)notification {
    self.drawWithTransition = YES;
    [self drawCardViews];
    self.drawWithTransition = NO;
}

- (void)resetGame {
    self.game = nil;
    [self.cardTapGestureRecognizer setEnabled:YES];
    [self updateScoreLabel];
    [self moveCardsToCardGraveYard];
    self.cardViewCollection = nil;
    self.finishedDealing = NO;
    [self createCardSubViews];
    
    if ([self isKindOfClass:[SetCardMatchingGameViewController class]]) {
        self.cardsInPlayCount = 12;
        self.cardsInPlayTotal = self.cardsInPlayCount;
        self.game.matchMode = 3;
    }
   
}

- (void)moveCardsToCardGraveYard {
    
    void (^removeCards)(UIView *) = ^(UIView *view) {
        [UIView animateWithDuration:1.0  animations:^{
            [self.addCardButton setEnabled:NO];
            [view setFrame:[self getMiddleFrame]];
        } completion:^(BOOL finished){
            [self removeSubViews:self.cardAreaView];
            [self drawCardViews];
            [self.addCardButton setEnabled:YES];
        }];
    };

    for (UIView *subview in self.cardAreaView.subviews) {
        if ([subview isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *view = (PlayingCardView *)subview;
            removeCards(view);
        }
        
        if ([subview isKindOfClass:[SetCardView class]]) {
            SetCardView *view = (SetCardView *)subview;
            removeCards(view);
        }
    }
    
}

- (CGRect)getMiddleFrame {
    return CGRectMake(CGRectGetMidX(self.view.frame), 0 - CGRectGetMaxY(self.view.frame), self.cardPileView.frame.size.width, self.cardPileView.frame.size.height);
}

#pragma mark - Buttons

- (IBAction)reDealButton:(UIButton *)sender {
    [self resetGame];
}


- (IBAction)addCardButton:(UIButton *)sender {
    
    [self checkForPenalty];
        
    long remainingCards = self.totalCard - self.cardsInPlayTotal;
    if (remainingCards > 0) {
        if(remainingCards > 3) {
            self.cardsInPlayCount += 3;
               self.cardsInPlayTotal +=3;
        } else {
            self.cardsInPlayCount += remainingCards;
            self.cardsInPlayTotal += remainingCards;
        }
        
        self.drawWithTransition = YES;
        [self drawCardViews];
        self.drawWithTransition = NO;
    } else {
        [self disableButton:self.addCardButton forSec:3.0];
        for (UIView *view in self.cardAreaView.subviews) {
            SetCardView *subview = (SetCardView *)view;
            [subview cardSpringAnimation:NO];
        }
    }
    
}

- (IBAction)cardHintButton:(UIButton *)sender {
    [self disableButton:self.cardHintButton forSec:3.0];
    if ([self isKindOfClass:[SetCardMatchingGameViewController class]]) {
    
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        for (UIView *view in self.cardAreaView.subviews) {
            SetCardView *setCardView = (SetCardView *)view;
            
            if (!setCardView.isMatched) {
                SetCard *card = [self.game.cards objectAtIndex:setCardView.tag];
               if (card) {
                    [cards addObject:card];
                }
            }
        }
        
        if ([cards count] > 0) {
            NSArray *firstCardsThatMatch = [self.game firstCardMatchInCardArray:cards];
            if (firstCardsThatMatch) {
                for (SetCard *card in firstCardsThatMatch) {
                    SetCardView *view = (SetCardView *)[self.cardViewCollection objectAtIndex:[self.game.cards indexOfObject:card]];
                    [view cardSpringAnimation:YES];
                }
            }
        } else {
            for (UIView *view in self.cardAreaView.subviews) {
                SetCardView *subview = (SetCardView *)view;
                [subview cardSpringAnimation:NO];
            }
        }
    }
}

#pragma mark - Update UI Methods

- (void)disableButton: (UIButton *)button forSec: (float)sec {
    [button setEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:sec repeats:NO block:^(NSTimer *timer) {
        [button setEnabled:YES];
    }];
}

- (void)updateMainUI {
    [self updateCardViewCollectionValues];
}

- (void)updateCardViewCollectionValues {
    BOOL hasRemovedACard = NO;
    for (UIView *subview in self.cardAreaView.subviews) {
        Card *card = [self.game cardAtIndex:subview.tag];
        
        if (card) {
        
            if ([subview isKindOfClass:[PlayingCardView class]]) {
                PlayingCardView *cardView = (PlayingCardView *)subview;
                if (cardView.isChosen != card.isChosen) {
                    cardView.isChosen = card.chosen;
                    [cardView cardFlipAnimation];
                }
                if (cardView.isMatched != card.isMatched) {
                    cardView.isMatched = card.matched;
                    [cardView cardMatchAnimation];
                }
            }

            if ([subview isKindOfClass:[SetCardView class]]) {
                SetCardView *cardView = (SetCardView *)subview;
                
                if (cardView.isChosen != card.isChosen) {
                    cardView.isChosen = card.isChosen;
                    [cardView cardChosenAnimation];
                }
                
                if (cardView.isMatched != card.isMatched) {
                    cardView.isMatched = card.isMatched;
                }
                
                if (cardView.isMatched && !cardView.isRemoved) {
                    [cardView cardMatchAnimation];
                    cardView.isRemoved = YES;
                    self.cardsInPlayCount--;
                    hasRemovedACard = YES;
                }
            }
        }
    }
        
    if (hasRemovedACard) {
        self.drawWithTransition = YES;
        [self drawCardViews];
        self.drawWithTransition = NO;
    }
        
}


- (void)updateScoreLabel {
    self.scoreLabel.text = [NSString stringWithFormat:
                            @"Score: %ld",
                            self.game.score
                            ];
}

#define ASPECT_RATIO_HEIGHT 4.5
#define ASPECT_RATIO_WIDTH 3.0

- (CGFloat)getAspectRatio {
    return ASPECT_RATIO_WIDTH  / ASPECT_RATIO_HEIGHT;;
}

- (CGRect)cardPileFrame {
    return CGRectMake(self.cardPileView.frame.origin.x - self.cardAreaView.frame.origin.x, self.cardPileView.frame.origin.y - self.cardAreaView.frame.origin.y, self.cardPileView.frame.size.width, self.cardPileView.frame.size.height);
    
}

- (Grid *)getCardAreaViewGrid {
    Grid *grid = [[Grid alloc] init];
    grid.cellAspectRatio = [self getAspectRatio];
    grid.size = self.cardAreaView.bounds.size;
    return grid;

}

- (void)drawCardViews {
    [self removeSubViews:self.cardAreaView];
    Grid *cardsAreaViewGrid = [self getCardAreaViewGrid];
    cardsAreaViewGrid.minimumNumberOfCells = self.cardsInPlayCount;

    int drawnCards = 0;
    int counter = 0;
    
    for (int i = 0; i < cardsAreaViewGrid.rowCount; i++) {
        for (int j = 0; j < cardsAreaViewGrid.columnCount; j++) {
            
            CGRect cardRect = [cardsAreaViewGrid frameOfCellAtRow:i inColumn:j];
            CGRect lowerMiddleFrame = CGRectMake(CGRectGetMidX(self.view.bounds),
                                                 CGRectGetMaxY(self.view.bounds),
                                                 cardsAreaViewGrid.size.width,
                                                 cardsAreaViewGrid.size.height);

            if ([self isKindOfClass:[PlayingCardMatchingGameViewController class]]) {
                PlayingCardView *view = (PlayingCardView *)[self.cardViewCollection objectAtIndex:counter];
                view.backgroundColor = [UIColor clearColor];
                if (drawnCards < self.totalCard) {

                    
                    if (!self.finishedDealing) {
                        view.frame = lowerMiddleFrame;
                        [view cardDealAnimationToRect: cardRect];
                    } else {
                        if (self.drawWithTransition) {
                            
                            if (view.inPile) {
                                cardRect = [self cardPileFrame];
                            }

                            [view cardDealAnimationToRect:cardRect];
                        } else {
                            view.frame = cardRect;
                        }
                    }
                    
                    
                    [self.cardAreaView addSubview:view];
                    drawnCards++;
                }
                counter++;
            }
                
            if ([self isKindOfClass:[SetCardMatchingGameViewController class]]) {
                BOOL matched = YES;
    
                while (matched) {
                    SetCardView *view = (SetCardView *)[self.cardViewCollection objectAtIndex: counter];
                    view.backgroundColor = [UIColor clearColor];
                    
                    if (!view.isRemoved) {
                    
                        if (!self.finishedDealing) {
                            view.frame = lowerMiddleFrame;
                            [view cardDealAnimationToRect:cardRect];
                        } else {
                            if (self.drawWithTransition) {
                                
                                if (view.inPile) {
                                    cardRect = [self cardPileFrame];
                                }
                                
                                [view cardDealAnimationToRect:cardRect];
                            } else {
                                view.frame = cardRect;
                            }
                            
                        }
                        
                        [self.cardAreaView addSubview:view];
                        matched = NO;
                        drawnCards++;
                    }
                    counter++;
                }
            }
            
            if (drawnCards >= self.cardsInPlayCount) {
                self.finishedDealing = YES;
                return;
            }
        }
    }
}

- (void)createCardSubViews {
    for (int i = 0; i < self.totalCard; i++) {
        if ([self isKindOfClass:[PlayingCardMatchingGameViewController class]]) {
            PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:i];
            if (card) {
                PlayingCardView *cardView = [[PlayingCardView alloc] init];
                cardView.rank = card.rank;
                cardView.suit = card.suit;
                cardView.isChosen = card.isChosen;
                cardView.isMatched = card.isMatched;
                cardView.tag = i;
                [self.cardViewCollection addObject:cardView];
            }
        }
            
        if ([self isKindOfClass:[SetCardMatchingGameViewController class]]) {

            SetCard *card = (SetCard *)[self.game cardAtIndex:i];
                
            if (card) {
                SetCardView *cardView = [[SetCardView alloc] init];
                cardView.color = card.color;
                cardView.numberOfShapes = card.numberOfShape;
                cardView.shade = card.shade;
                cardView.shape = card.shape;
                cardView.isChosen = card.isChosen;
                cardView.tag = i;
                [self.cardViewCollection addObject:cardView];
            }
        }
    }
}

- (void)removeSubViews: (UIView *)view {
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)checkForPenalty {
    if ([self isKindOfClass:[SetCardMatchingGameViewController class]]) {
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        for (UIView *view in self.cardAreaView.subviews) {
            SetCardView *setCardView = (SetCardView *)view;
            
            if (!setCardView.isMatched) {
                SetCard *card = [self.game.cards objectAtIndex:setCardView.tag];
               if (card) {
                    [cards addObject:card];
                }
            }
        }
        [self.game addCardPenalty:cards];
        [self updateScoreLabel];
    }
}

#pragma mark - Helper methods
+ (NSString *)defaultFont {
    return @"Helvetica-BoldOblique";
}

+ (float)defaultFontSize {
    return 13.0f;
}

+ (NSDictionary *)defaultAttributesForContents {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[NSFontAttributeName] = [UIFont fontWithName:[CardMatchingGameViewController defaultFont]
                                                size:[CardMatchingGameViewController defaultFontSize]];
    return dict;
}

+ (NSAttributedString *)applyDefaultAttributesToString: (NSString *)str {
    return [[NSAttributedString alloc] initWithString:str attributes:[CardMatchingGameViewController defaultAttributesForContents]];
}

@end
