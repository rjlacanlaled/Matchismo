//
//  SettingsViewController.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/14/21.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISlider *matchPointSlider;
@property (weak, nonatomic) IBOutlet UISlider *pointMultiplierSlider;
@property (weak, nonatomic) IBOutlet UISlider *costToChooseSlider;
@property (weak, nonatomic) IBOutlet UISlider *mismatchPenaltySlider;
@property (weak, nonatomic) IBOutlet UISlider *maxPlayingCardSlider;
@property (weak, nonatomic) IBOutlet UISlider *maxSetCardSlider;
@property (weak, nonatomic) IBOutlet UILabel *matchPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *costToChooseLabel;
@property (weak, nonatomic) IBOutlet UILabel *mismatchPenaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPlayingCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSetCardLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - Sliders

- (IBAction)matchPointSliderValueChanged:(UISlider *)sender {
    [CardMatchingGame setMatchPoint:(int)self.matchPointSlider.value];
    [self updateMatchPointLabel];
}

- (IBAction)pointMultiplierValueChanged:(UISlider *)sender {
    [CardMatchingGame setPointMultiplier:(int)self.pointMultiplierSlider.value];
    [self updatePointMultiplierLabel];
}

- (IBAction)costToChooseSliderValueChanged:(UISlider *)sender {
    [CardMatchingGame setCostToChoose:(int)self.costToChooseSlider.value];
    [self updateCostToChooseLabel];
}

- (IBAction)mismatchPenaltyValueChanged:(UISlider *)sender {
    [CardMatchingGame setMismatchPenalty:(int)self.mismatchPenaltySlider.value];
    [self updateMismatchPenaltyLabel];
}

- (IBAction)maxPlayingCardValueChanged:(UISlider *)sender {
    [CardMatchingGame setMaxPlayingCard:(int)self.maxPlayingCardSlider.value];
    [self updateMaxPlayingCardLabel];
}


- (IBAction)maxSetCardValueChanged:(UISlider *)sender {
    [CardMatchingGame setMaxSetCard:(int)self.maxSetCardSlider.value];
    [self updateMaxSetCardLabel];
}

#pragma mark - Update UI Methods

- (void)updateUI {
    [self updateSliderValue];
    [self updateLabelText];
}

- (void)updateMatchPointLabel {
    self.matchPointLabel.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
     [self valueForMatchPointLabel]];
}

- (void)updatePointMultiplierLabel {
    self.pointMultiplierLabel.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
     [self valueForPointMultiplierLabel]];
}

- (void)updateCostToChooseLabel {
    self.costToChooseLabel.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
     [self valueForCostToChooseLabel]];
}

- (void)updateMismatchPenaltyLabel {
    self.mismatchPenaltyLabel.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
     [self valueForMismatchPenaltyLabel]];
}

- (void)updateMaxPlayingCardLabel {
    self.maxPlayingCardLabel.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
     [self valueForMaxPlayingCardLabel]];
}

- (void)updateMaxSetCardLabel {
    self.maxSetCardLabel.attributedText =
    [CardMatchingGameViewController applyDefaultAttributesToString:
     [self valueForMaxSetCardLabel]];
}

- (void)updateLabelText {
    [self updateMatchPointLabel];
    [self updatePointMultiplierLabel];
    [self updateCostToChooseLabel];
    [self updateMismatchPenaltyLabel];
    [self updateMaxPlayingCardLabel];
    [self updateMaxSetCardLabel];

}

- (void)updateSliderValue {
    [self updateMatchPointSliderValue];
    [self updatePointMultiplierSliderValue];
    [self updateCostToChooseSliderValue];
    [self updateMismatchPenaltySliderValue];
    [self updateMaxPlayingCardSliderValue];
    [self updateMaxSetCardSliderValue];
}


- (void)updateMatchPointSliderValue {
    self.matchPointSlider.value = CardMatchingGame.matchPoint;
}

- (void)updatePointMultiplierSliderValue {
    self.pointMultiplierSlider.value = CardMatchingGame.pointMultiplier;
}

- (void)updateCostToChooseSliderValue {
    self.costToChooseSlider.value = CardMatchingGame.costToChoose;
}

- (void)updateMismatchPenaltySliderValue {
    self.mismatchPenaltySlider.value = CardMatchingGame.mismatchPenalty;
}

- (void) updateMaxPlayingCardSliderValue{
    self.maxPlayingCardSlider.value = CardMatchingGame.maxPlayingCard;
}

- (void)updateMaxSetCardSliderValue {
    self.maxSetCardSlider.value = CardMatchingGame.maxSetCard;
}



#pragma mark - Helper Methods

- (NSString *)valueForPointMultiplierLabel {
    return [NSString stringWithFormat:
            @"Point Multiplier: %d",
            (int)self.pointMultiplierSlider.value
            ];
}

- (NSString *)valueForMatchPointLabel {
    return [NSString stringWithFormat:
            @"Match Point: %d",
            (int)self.matchPointSlider.value
            ];
}

- (NSString *)valueForCostToChooseLabel {
    return [NSString stringWithFormat:
            @"Cost to Choose: %d",
            (int)self.costToChooseSlider.value
            ];
}

- (NSString *)valueForMismatchPenaltyLabel {
    return [NSString stringWithFormat:
            @"Mismatch Penalty: %d",
            (int)self.mismatchPenaltySlider.value
            ];
}

- (NSString *)valueForMaxPlayingCardLabel {
    return [NSString stringWithFormat:
            @"Max Playing Card: %d",
            (int)self.maxPlayingCardSlider.value
            ];
}

- (NSString *)valueForMaxSetCardLabel {
    return [NSString stringWithFormat:
            @"Max Set Card: %d",
            (int)self.maxSetCardSlider.value
            ];
}

@end

