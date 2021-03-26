//
//  Shade.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "Shade.h"

@implementation Shade

- (instancetype)initWithName:(NSString *)name
                       alpha:(float)alpha
                    isFilled:(BOOL)isFilled
                   isStriped:(BOOL)isStriped {
    
    self = [super init];
    
    if (self) {
        _name = name;
        alpha = alpha;
        _isFilled = isFilled;
        _isStriped = isStriped;
    }
    
    return self;
}

@end
