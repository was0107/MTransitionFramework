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

@property (nonatomic, strong) UIButton *button;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.title length] == 0) {
        self.title = NSStringFromClass([self class]);
    }
    self.view.backgroundColor = [UIColor whiteColor];
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:self.title forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor redColor];
        _button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2-130, 100, 260, 50);
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationTransitioning.enable = NO;
    [self.navigationController resetNavigationDelegate];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    self.navigationTransitioning.enable = YES;

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
    self.navigationTransitioning = [[MNavigationTransitioningLeftPush alloc] initWithController:self];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    ((MNavigationTransitioningLeftPush *)self.navigationTransitioning).delegate = self;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationTransitioning.enable = NO;
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


@implementation CenterViewController



- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationTransitioning = [[NSClassFromString(@"MNavigationTransitioningCenter") alloc] initWithController:self];
    ((MNavigationTransitioningCenter*) self.navigationTransitioning).originRect = CGRectMake(0, CGRectGetHeight(self.view.bounds)/2, CGRectGetWidth(self.view.bounds), 0);
}

@end



@implementation ModalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationTransitioning = [[NSClassFromString(@"MNavigationTransitioningModal") alloc] initWithController:self];
}


@end


@implementation CustomViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationTransitioning = [[NSClassFromString(@"MNavigationTransitioning") alloc] initWithController:self];
    __weak __typeof(self)weakSelf = self;

    [((MNavigationTransitioning*) self.navigationTransitioning)
     transitionWithPresenting:^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = weakSelf.button.frame;
        button.backgroundColor = weakSelf.button.backgroundColor;
        [button setTitle:weakSelf.button.titleLabel.text forState:UIControlStateNormal];
        [trans.containerView addSubview:button];
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             button.frame = trans.containerView.bounds;
             button.alpha = 0;
             
         }
                         completion:^(BOOL finished)
         {

             [button removeFromSuperview];
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
         }];
    }
     
     end:^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)
    {
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             
         }
                         completion:^(BOOL finished)
         {
             
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
         }];
    }];
}

@end
