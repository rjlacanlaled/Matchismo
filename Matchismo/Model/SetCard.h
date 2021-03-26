//
//  SetCard.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "Card.h"
#import "Color.h"
#import "Shade.h"
#import "Shape.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger numberOfShape;
@property (nonatomic) Shape *shape;
@property (nonatomic) Shade *shade;
@property (nonatomic) Color *color;
@property (strong, nonatomic) NSString *matchResult;

+ (NSUInteger)maxNumberOfShape;
+ (NSArray *)validColors;
+ (NSArray *)validShapes;
+ (NSArray *)validShades;

@end
