//
//  MainTableViewController.m
//  MTransitionFramework
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController {
    NSArray *_datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = @[@{@"name":@"左滑进入", @"class":@"LeftPushViewController"},
               @{@"name":@"居中进入", @"class":@"LeftPushViewController"},
               @{@"name":@"模态进入", @"class":@"ModalViewController"}];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = _datas[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller = [[NSClassFromString(_datas[indexPath.row][@"class"]) alloc] init];
    controller.title = _datas[indexPath.row][@"name"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
