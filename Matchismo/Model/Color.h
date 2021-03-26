//
//  Color.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import <Foundation/Foundation.h>

@interface Color : NSObject

// designated initializer
- (instancetype)initWithName:(NSString *)name
                 red:(float)red
               green:(float)green
                blue:(float)blue;

@property (strong, nonatomic) NSString *name;
@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;

@end

