//
//  CountryChooseController.m
//  CountrySelectViewController
//
//  Created by Soldier on 15/9/28.
//  Copyright © 2015年 Shaojie Hong. All rights reserved.
//

#import "CountryChooseController.h"
#import "NSDictionary-DeepMutableCopy.h"

@interface CountryChooseController ()

@end


@implementation CountryChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat navigationBarHeight = 64;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navigationBarHeight)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    [navigationItem setTitle:@"Country Choose"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    _search = [[UISearchBar alloc] init];
    _search.delegate = self;
    _search.frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, 44);
    [self.view addSubview:_search];
    
    CGFloat top = navigationBarHeight + _search.frame.size.height;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight + _search.frame.size.height, self.view.frame.size.width, self.view.bounds.size.height - top) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"country_en" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.allNames = dict;
    
    [self resetSearch];
    [_table reloadData];
}

- (void)resetSearch {
    NSMutableDictionary *allNamesCopy = [self.allNames mutableDeepCopy];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] 
                                   sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
}

- (void)handleSearchForTerm:(NSString *)searchTerm {
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.keys) {
        NSMutableArray *array = [_names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in array) {
            if ([name rangeOfString:searchTerm 
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [_table reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_keys count] == 0) {
        return 0;
    }
    
    NSString *key = [_keys objectAtIndex:section];
    NSArray *nameSection = [_names objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSString *key = [_keys objectAtIndex:section];
    NSArray *nameSection = [_names objectForKey:key];
    
    static NSString *SectionsTableIdentifier = @"TableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier: SectionsTableIdentifier];
    }
    
    NSString *str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range = [str1 rangeOfString:@"+"];
    NSString *str2 = [str1 substringFromIndex:range.location];
    NSString *areaCode = [str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *countryName = [str1 substringToIndex:range.location];

    cell.textLabel.text = countryName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@", areaCode];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_keys count] == 0) {
        return nil;
    }
    NSString *key = [_keys objectAtIndex:section];
    if (key == UITableViewIndexSearch) {
        return nil;
    }
    
    return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (_isSearching) {
        return nil;
    }
    
    return _keys;
}

#pragma mark -

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_search resignFirstResponder];
    _search.text = @"";
    _isSearching = NO;
    [tableView reloadData];
    
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *key = [_keys objectAtIndex:index];
    if (key == UITableViewIndexSearch) {
        [tableView setContentOffset:CGPointZero animated:NO];
        
        return NSNotFound;
    } else {
        return index;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSString *key = [_keys objectAtIndex:section];
    NSArray *nameSection = [_names objectForKey:key];
    
    NSString *str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range = [str1 rangeOfString:@"+"];
    NSString *str2 = [str1 substringFromIndex:range.location];
    NSString *areaCode = [str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *countryName = [str1 substringToIndex:range.location];

    CountryAndAreaCode *country = [[CountryAndAreaCode alloc] init];
    country.countryName = countryName;
    country.areaCode = areaCode;
    
    NSLog(@"%@ %@", countryName, areaCode);
    
    [self.view endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setSecondData:)]) {
        [self.delegate setSecondData:country];
    }
    
    //关闭当前
    [self clickLeftButton];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _isSearching = YES;
    [_table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar 
    textDidChange:(NSString *)searchTerm {
    if ([searchTerm length] == 0) {
        [self resetSearch];
        [_table reloadData];
        
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _isSearching = NO;
    _search.text = @"";

    [self resetSearch];
    [_table reloadData];
    
    [searchBar resignFirstResponder];
}

- (void)clickLeftButton {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
