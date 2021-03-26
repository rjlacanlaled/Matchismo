//
//  CardBounceBehavior.h
//  Matchismo
//
//  Created by RJ Lacanlale on 1/16/21.
//

#import <UIKit/UIKit.h>

@interface CardBounceBehavior : UIDynamicBehavior
- (void)addItem: (id <UIDynamicItem>) item;
- (void)removeItem: (id <UIDynamicItem>) item;
@end
