//
//  CountryChooseController.h
//  AreaCodeSelectViewController
//
//  Created by Soldier on 15/9/28.
//  Copyright © 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CountryAndAreaCode.h"

@protocol CountryChooseControllerDelegate;

@interface CountryChooseController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate> {
    BOOL _isSearching;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) NSDictionary *allNames;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, weak) id<CountryChooseControllerDelegate> delegate;
@property (nonatomic, strong) UIToolbar *toolBar;

- (void)resetSearch;

- (void)handleSearchForTerm:(NSString *)searchTerm;

@end



@protocol CountryChooseControllerDelegate <NSObject>

- (void)setSecondData:(CountryAndAreaCode *)data;

@end


