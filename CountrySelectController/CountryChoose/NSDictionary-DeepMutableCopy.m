//
//  NSDictionary-DeepMutableCopy.m
//  AreaCodeSelectViewController
//
//  Created by Soldier on 15/9/28.
//  Copyright © 2015年 Shaojie Hong. All rights reserved.
//

#import "NSDictionary-DeepMutableCopy.h"

@implementation NSDictionary(DeepMutableCopy)

-(NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray *keys = [self allKeys];
    for (id key in keys) {
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        } else if ([oneValue respondsToSelector:@selector(mutableCopy)]) {
            oneCopy = [oneValue mutableCopy];
        }
        if (oneCopy == nil) {
            oneCopy = [oneValue copy];
        }
        
        [ret setValue:oneCopy forKey:key];
    }
    return ret;
}

@end
