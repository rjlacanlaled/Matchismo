//
//  Shape.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "Shape.h"

@implementation Shape

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    
    if (self) {
        _name = name;
    }
    
    return self;
}

@end
