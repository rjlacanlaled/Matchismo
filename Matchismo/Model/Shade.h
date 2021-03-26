//
//  Shade.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import <Foundation/Foundation.h>

@interface Shade : NSObject

//designated initializer
- (instancetype)initWithName:(NSString *)name
                       alpha:(float)alpha
                    isFilled:(BOOL)isFilled
                   isStriped:(BOOL)isStriped;

@property (strong, nonatomic) NSString *name;
@property (nonatomic) float alpha;
@property (nonatomic) BOOL isFilled;
@property (nonatomic) BOOL isStriped;

@end

