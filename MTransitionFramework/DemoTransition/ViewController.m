//
//  ViewController.m
//  DemoTransition
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+Transitioning.h"

@interface BaseViewController()

@property (nonatomic, strong) MNavigationTransitioningBase *navigationTransitioning;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.title length] == 0) {
        self.title = NSStringFromClass([self class]);
    }
    self.view.backgroundColor = [UIColor whiteColor];
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.title forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2-130, 100, 260, 50);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self.navigationTransitioning;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController resetNavigationDelegate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    BaseViewController *controller = [[BaseViewController alloc] init];
    controller.title = @"Demo";
    [self.navigationController pushViewController:controller animated:YES];
}

@end



@interface LeftPushViewController()<MNavigationTransitioningLeftPushDelegate>

@end


@implementation LeftPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTransitioning = [[MNavigationTransitioningLeftPush alloc] initWithNavigationController:self.navigationController];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ((MNavigationTransitioningLeftPush *)self.navigationTransitioning).delegate = self;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    ((MNavigationTransitioningLeftPush *)self.navigationTransitioning).delegate = nil;
}

#pragma mark -- MNavigationTransitioningLeftPushDelegate

- (void) responseToNavigationLeftPush {
    [self buttonAction:nil];
}

- (BOOL) canResponseToNavigationLeftPush {
    return YES;
}

@end


@implementation ModalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationTransitioning = [[NSClassFromString(@"MNavigationTransitioningModal") alloc] initWithNavigationController:self.navigationController];
}

@end
