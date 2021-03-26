//
//  Shape.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/8/21.
//

#import <Foundation/Foundation.h>

@interface Shape : NSObject

//designated initializer
- (instancetype)initWithName:(NSString *)name;

@property (strong, nonatomic) NSString *name;

@end

