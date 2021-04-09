//
//  ViewController.m
//  DemoTransition
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+Transitioning.h"
#import "MLiveFloatingView.h"
#import "MNavigationPresenting.h"

#import <objc/runtime.h>

@interface BaseViewController()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MLiveFloatingView *floatingView;
@end

@implementation BaseViewController

- (void) dealloc {
    NSLog(@"deallllloc d = %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.title length] == 0) {
        self.title = NSStringFromClass([self class]);
    }
    NSLog(@"viewDidLoad = %@ || %@", self, self.title);
    self.view.backgroundColor = [UIColor whiteColor];
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:self.title forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor redColor];
        _button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2-130, 100, 260, 50);
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
    
    {
        self.floatingView = [[MLiveFloatingView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-130, 200, 110, 36)];
        self.floatingView.enableMove = YES;
        self.floatingView.backgroundColor = [UIColor clearColor];
//        self.floatingView.disableEdgeInsets = UIEdgeInsetsMake(64, CGRectGetWidth(self.view.bounds)-90, 0, -20);
        self.floatingView.disableEdgeInsets = UIEdgeInsetsMake(64, 0, 0, -20);
        self.floatingView.stopPosition = MFloatingStopPositionAll;
        __weak __typeof(self)weakSelf = self;

        self.floatingView.touchBlock = ^(NSUInteger touchState, NSSet * _Nonnull touches, UIEvent * _Nonnull event) {
            if (MFloatingTouchTypeBegan == touchState) {
                if ([weakSelf.navigationTransitioning isKindOfClass: [MNavigationTransitioningLeftPush class]]) {
                    MNavigationTransitioningLeftPush *leftPush = (MNavigationTransitioningLeftPush *)weakSelf.navigationTransitioning;
                    leftPush.leftPushPanGesture.enabled = NO;
                }
            }
            else if (MFloatingTouchTypeMoved != touchState) {
                if ([weakSelf.navigationTransitioning isKindOfClass: [MNavigationTransitioningLeftPush class]]) {
                    MNavigationTransitioningLeftPush *leftPush = (MNavigationTransitioningLeftPush *)weakSelf.navigationTransitioning;
                    leftPush.leftPushPanGesture.enabled = YES;
                }
            }
        };
        self.floatingView.singleTapBlock = ^{
            [weakSelf buttonAction:nil];
        };
        [self.view addSubview:self.floatingView];
        self.navigationTransitioning.enable = NO;
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
    self.navigationTransitioning.enable = YES;

//    ((MNavigationTransitioningLeftPush *)self.navigationTransitioning).delegate = self;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationTransitioning.enable = NO;
//    ((MNavigationTransitioningLeftPush *)self.navigationTransitioning).delegate = nil;
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(doneAction:)];
}

- (void) doneAction:(id) sender {
    if (self.parenetController) {
        MNavigationTransitioning * transion = objc_getAssociatedObject(self.parenetController, &MNavigation);;
        if (!transion) {
            transion = [[NSClassFromString(@"MNavigationTransitioningModal") alloc] initWithController:self.parenetController];
            transion.enable = YES;
            objc_setAssociatedObject(self.parenetController, &MNavigation, transion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

static char MNavigation;
- (void) setParenetController:(UIViewController *)parenetController {
    [super setParenetController:parenetController];
    
    if (parenetController) {
        MNavigationTransitioning * transion = objc_getAssociatedObject(parenetController, &MNavigation);;
        if (!transion) {
            transion = [[NSClassFromString(@"MNavigationTransitioningModal") alloc] initWithController:parenetController];
            transion.enable = YES;
            objc_setAssociatedObject(parenetController, &MNavigation, transion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.parenetController) {
        MNavigationTransitioning * transion = objc_getAssociatedObject(self.parenetController, &MNavigation);;
        transion.enable = YES;
    }
    
}



- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.parenetController) {
        MNavigationTransitioning * transion = objc_getAssociatedObject(self.parenetController, &MNavigation);;
        transion.enable = NO;
        objc_setAssociatedObject(self.parenetController, &MNavigation, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (IBAction)buttonAction:(id)sender {
    if (self.parenetController) {
        MNavigationTransitioning * transion = objc_getAssociatedObject(self.parenetController, &MNavigation);;
        transion.enable = NO;
    }
    BaseViewController *controller = [[BaseViewController alloc] init];
    controller.title = @"Demo";
    [self.navigationController pushViewController:controller animated:YES];
}
@end


@implementation CustomViewController


//- (IBAction)buttonAction:(id)sender {
//    self.navigationTransitioning.enable = YES;
//
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
        CGRect transFrame = trans.containerView.frame;
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
            trans.fromView.frame = CGRectMake(0, CGRectGetHeight(transFrame)/2 - 40, CGRectGetWidth(transFrame), 80);
            trans.fromView.alpha = 0;

         }
                         completion:^(BOOL finished)
         {
             
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
         }];
    }];
}

@end


@implementation HalfModalPresentedViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

//    self.navigationTransitioning = [[NSClassFromString(@"MNavigationTransitioning") alloc] initWithController:self];

//    
//    self.transitioningDelegate = self.navigationTransitioning;
//    self.navigationTransitioning.enable = YES;
}

- (IBAction)buttonAction:(id)sender {
    HalfModalPresentingViewController *controller = [[HalfModalPresentingViewController alloc] init];
    controller.title = @"Demo";
    
    controller.orignController = self;
    [self presentViewController:controller animated:YES completion:nil];
}
@end


@interface MYZSTGestureDelegate : NSObject<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *disableGestures;
@end

@implementation MYZSTGestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self.disableGestures containsObject:otherGestureRecognizer]) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end


@interface HalfModalPresentingViewController()

@property (nonatomic, strong) MYZSTGestureDelegate *delegate;
@end


@implementation HalfModalPresentingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationTransitioning = [[NSClassFromString(@"MNavigationPresenting") alloc] initWithController:self];
        self.transitioningDelegate = self.navigationTransitioning;
        self.modalPresentationStyle = UIModalPresentationFullScreen;

        MNavigationPresenting *transioning = (MNavigationPresenting *)self.navigationTransitioning;
        transioning.presenting = YES;
        transioning.animateTime = 0.25;
        __weak __typeof(self)weakSelf = self;
        transioning.backViewTapedBlock = ^{
            [weakSelf buttonAction:nil];
        };
    }
    return self;
}

- (MYZSTGestureDelegate *) delegate {
    if (!_delegate) {
        _delegate = [[MYZSTGestureDelegate alloc] init];
    }
    return _delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MNavigationPresenting *transioning = (MNavigationPresenting *)self.navigationTransitioning;
    transioning.panGesture.delegate = self.delegate;
    
    BOOL useScrollView = YES;
    
    if (useScrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 2);
        [self.scrollView addSubview:self.button];
        [self.view addSubview:self.scrollView];
        [self.scrollView addGestureRecognizer:transioning.panGesture];
    } else {
        [self.view addGestureRecognizer:transioning.panGesture];
    }
    
    
    self.view.backgroundColor = [UIColor grayColor];
}

- (IBAction)buttonAction:(id)sender {
    MNavigationTransitioning *transioning = (MNavigationTransitioning *)self.navigationTransitioning;
    transioning.presenting = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
