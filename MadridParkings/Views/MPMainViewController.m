//
//  MPMainViewController.m
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 24/12/2018.
//  Copyright © 2018 Rafael Gil. All rights reserved.
//

#import "MPMainViewController.h"
#import "MPEntityCellView.h"
#import "MPEntityViewModelProtocol.h"

@interface MPMainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *items;

@end

@implementation MPMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _items = [NSArray new];
    
    [self.presenter viewLoaded];
}
#pragma mark - private methods

- (void)setupTable {
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 74;
}

#pragma mark - MPMainViewProtocol

-(UINavigationController *)getNavigationView {
    return self.navigationController;
}

- (void)hideLoadingIndicator {
    
    [self.view hideLoadingIndicator];
}

- (void)showLoadingIndicator {
    
    [self.view showLoadingIndicator];
}

-(void)showEntities:(NSArray *)entites {
    
    _items = entites;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSoruce - UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MPEntityCellView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MPEntityCellView.class)];
    [cell bindEntity:self.items[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

@end

