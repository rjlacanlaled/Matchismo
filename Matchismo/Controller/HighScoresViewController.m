//
//  HighScoresViewController.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/6/21.
//

#import "HighScoresViewController.h"


@interface HighScoresViewController ()
@property (weak, nonatomic) IBOutlet UITextView *gameTypeTextView;
@property (weak, nonatomic) IBOutlet UITextView *scoreTextView;
@property (weak, nonatomic) IBOutlet UITextView *durationTextView;
@property (weak, nonatomic) IBOutlet UITextView *dateTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortTypeSegmentedControl;

@property (strong, nonatomic) NSArray *sortedHighScoreArray;

@end

@implementation HighScoresViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateHighScoreUI];
}


#pragma mark - UI Update Methods

- (void)updateHighScoreUI {
    [self sortArray:[self.game getHighScoresForGame:[self valueForSelectedGameType]]];
    [self updateGameTypeTextView];
    [self updateScoreTextView];
    [self updateDurationTextView];
    [self updateDateTextView];
}

- (void)updateGameTypeTextView {
    self.gameTypeTextView.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
    [self getStringVersionForGameType:self.sortedHighScoreArray]];
}

- (void)updateScoreTextView {
    self.scoreTextView.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
    [self getStringVersionForScores:self.sortedHighScoreArray]];
}

- (void)updateDurationTextView {
    self.durationTextView.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
    [self getStringVersionForDuration:self.sortedHighScoreArray]];
}

- (void)updateDateTextView {
    self.dateTextView.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
    [self getStringVersionForDate:self.sortedHighScoreArray]];
}

#pragma mark - Helper Methods

- (float)minuteVersionForSeconds: (float)seconds {
    return seconds / 60.0;
}

- (NSString *)valueForSelectedGameType{
    switch (self.gameTypeSegmentedControl.selectedSegmentIndex) {
        case 1:
            return @"PlayingCard";
            break;
        case 2:
            return @"Set";
        default:
            return @"All";
            break;
    }
}

- (NSDictionary *)valueForSelectedSortType {
    NSMutableDictionary *sortType = [[NSMutableDictionary alloc] init];

    switch(self.sortTypeSegmentedControl.selectedSegmentIndex) {
        case 1:
            [sortType setObject:@"score" forKey:@"sortCategory"];
            [sortType setObject:[NSNumber numberWithBool:YES] forKey:@"isAscending"];
            break;
        case 2:
            [sortType setObject:@"time" forKey:@"sortCategory"];
            [sortType setObject:[NSNumber numberWithBool:NO] forKey:@"isAscending"];
            break;
        case 3:
            [sortType setObject:@"time" forKey:@"sortCategory"];
            [sortType setObject:[NSNumber numberWithBool:YES] forKey:@"isAscending"];
            break;
        case 4:
            [sortType setObject:@"duration" forKey:@"sortCategory"];
            [sortType setObject:[NSNumber numberWithBool:YES] forKey:@"isAscending"];
            break;
        case 5:
            [sortType setObject:@"duration" forKey:@"sortCategory"];
            [sortType setObject:[NSNumber numberWithBool:NO] forKey:@"isAscending"];
            break;
        default:
            [sortType setObject:@"score" forKey:@"sortCategory"];
            [sortType setObject:[NSNumber numberWithBool:NO] forKey:@"isAscending"];
            break;
    }
    return sortType;
}

- (void)sortArray: (NSArray *)unsortedArray {
    
    NSDictionary *sortType = [self valueForSelectedSortType];
    self.sortedHighScoreArray = [self.game sortArrayByCategory:[sortType objectForKey:@"sortCategory"] array:unsortedArray isAscending:[[sortType objectForKey:@"isAscending"] boolValue]];
    
}

- (NSArray *)sortedHighScoreArray {
    if (!_sortedHighScoreArray) {
        _sortedHighScoreArray = [[NSArray alloc] init];
    }
    return _sortedHighScoreArray;
}

- (NSString *)getStringVersionForScores: (NSArray *)highScores {
    NSString *highScoreString = @"Score\n";
    for (NSDictionary *highScore in highScores) {
        NSString *scoreDetails = [[highScore objectForKey:@"score"] stringValue];
        highScoreString = [highScoreString stringByAppendingString:scoreDetails];
        highScoreString = [highScoreString stringByAppendingString:@"\n"];
    }
    return highScoreString;
}

- (NSString *)getStringVersionForGameType: (NSArray *)highScores {
    NSString *gameTypeString = @"Game Type\n";
    for (NSDictionary *highScore in highScores) {
        NSString *gameTypeDetails = [highScore objectForKey:@"gameType"];
        gameTypeString = [gameTypeString stringByAppendingString:gameTypeDetails];
        gameTypeString = [gameTypeString stringByAppendingString:@"\n"];
    }
    return gameTypeString;
}

- (NSString *)getStringVersionForDuration: (NSArray *)highScores {
    NSString *gameDurationString = @"Duration\n";
    for (NSDictionary *highScore in highScores) {
        NSString *gameDurationDetails =  [self getStringVersionOfFloat: [self minuteVersionForSeconds: [[highScore objectForKey:@"duration"] floatValue]]
            withPrecision:2];
        gameDurationString =
        [gameDurationString stringByAppendingString:gameDurationDetails];
        gameDurationString =
        [gameDurationString stringByAppendingString:@"min\n"];
    }
    return gameDurationString;
}

- (NSString *)getStringVersionForDate: (NSArray *)highScores {
    NSString *dateString = @"Date\n";
    for (NSDictionary *highScore in highScores) {
        NSString *dateStringDetails = [self getShortVersionOfDateAndTime:
                                       [highScore objectForKey:@"time"]];
        dateString = [dateString stringByAppendingString:dateStringDetails];
        dateString = [dateString stringByAppendingString:@"\n"];
    }
    return dateString;
}

- (NSString *)getShortVersionOfDateAndTime: (NSDate *)date {
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)getStringVersionOfFloat: (float)value withPrecision: (int)precision {
    return [NSString stringWithFormat:
                            @"%.*f",
                            precision,
                            value
                            ];
}

#pragma mark - Segmented Controls

- (IBAction)gameTypeSegmentedControlValueChanged:(UISegmentedControl *)sender {
    [self updateHighScoreUI];
}

- (IBAction)sortTypeSegmentedControlValueChanged:(UISegmentedControl *)sender {
    [self updateHighScoreUI];
}

@end
