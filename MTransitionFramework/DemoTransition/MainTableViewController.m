//
//  MainTableViewController.m
//  MTransitionFramework
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MainTableViewController.h"
#import "MNavigationTransitioning.h"
#import "ViewController.h"

@interface MainTableViewController ()
@property (nonatomic, strong) MNavigationTransitioning *navigationTransitioning;

@end

@implementation MainTableViewController {
    NSArray *_datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = @[@{@"name":@"左滑进入", @"class":@"LeftPushViewController"},
               @{@"name":@"居中进入", @"class":@"CenterViewController"},
               @{@"name":@"模态进入", @"class":@"ModalViewController"},
               @{@"name":@"自定义",   @"class":@"CustomViewController"}];
    
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
    BaseViewController *controller = [[NSClassFromString(_datas[indexPath.row][@"class"]) alloc] init];

    if (2 == indexPath.row) {
        controller.parenetController = self;
//        self.navigationTransitioning = [[NSClassFromString(@"MNavigationTransitioningModal") alloc] initWithController:self];
//        self.navigationTransitioning.enable = YES;
    }
    controller.title = _datas[indexPath.row][@"name"];
    NSLog(@"self.nav = %@", self.navigationController);
    NSLog(@"self.nav.delegate = %@", self.navigationController.delegate);
    [self.navigationController pushViewController:controller animated:YES];
    if (2 == indexPath.row) {
    }

}
@end
