//
//  NSDictionary-DeepMutableCopy.h
//  AreaCodeSelectViewController
//
//  Created by Soldier on 15/9/28.
//  Copyright © 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(DeepMutableCopy)

- (NSMutableDictionary *)mutableDeepCopy;

@end
