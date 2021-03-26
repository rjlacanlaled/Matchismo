//
//  CardBounceBehavior.m
//  Matchismo
//
//  Created by RJ Lacanlale on 1/16/21.
//

#import "CardBounceBehavior.h"

@interface CardBounceBehavior()
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;
@end

@implementation CardBounceBehavior

- (instancetype)init {
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
    [self addChildBehavior:self.dynamicItemBehavior];
    return self;
}

- (UIDynamicItemBehavior *)dynamicItemBehavior {
    if (!_dynamicItemBehavior) {
        _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] init];
        _dynamicItemBehavior.elasticity = 1.0;
        _dynamicItemBehavior.allowsRotation = NO;
        _dynamicItemBehavior.friction = 10.0;
        
    }
    return _dynamicItemBehavior;
}

- (UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = -0.2;
    }
    return _gravity;
}

- (UICollisionBehavior *) collider {
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
    }
    return _collider;
}

- (void)addItem:(id<UIDynamicItem>)item {
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.dynamicItemBehavior addItem:item];
}

- (void)removeItem:(id<UIDynamicItem>)item {
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.dynamicItemBehavior removeItem:item];
}
@end
