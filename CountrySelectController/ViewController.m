//
//  ViewController.m
//  CountrySelectController
//
//  Created by Shaojie Hong on 15/9/28.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _areaCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width - 20, 50)];
    _areaCodeLab.textAlignment = NSTextAlignmentCenter;
    _areaCodeLab.textColor = [UIColor whiteColor];
    _areaCodeLab.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_areaCodeLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 75, 250, 150, 50);
    [btn setTitle:@"Country Choose" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showCountryView) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
}

- (void)showCountryView {
    CountryChooseController *countryView = [[CountryChooseController alloc] init];
    countryView.delegate = self;
    
    [self presentViewController:countryView animated:YES completion:^{
        
    }];
}

#pragma mark - SecondViewController Delegate

- (void)setSecondData:(CountryAndAreaCode *)data {
    self.areaCodeLab.text = [NSString stringWithFormat:@"%@  +%@", data.countryName, data.areaCode ];
}

@end
