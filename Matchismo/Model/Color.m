//
//  Color.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import "Color.h"

@implementation Color

- (instancetype)initWithName:(NSString *)name
                 red:(float)red
               green:(float)green
                blue:(float)blue {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _red = red;
        _green = green;
        _blue = blue;
    }
    
    return self;
    
}

@end
