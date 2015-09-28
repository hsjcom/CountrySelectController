//
//  ViewController.h
//  CountrySelectController
//
//  Created by Shaojie Hong on 15/9/28.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryChooseController.h"

@interface ViewController : UIViewController<CountryChooseControllerDelegate>

@property (nonatomic, strong) UILabel *areaCodeLab;


@end

