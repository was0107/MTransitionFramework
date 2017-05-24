//
//  MNavigationTransitioning.m
//  testLeftPush
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationTransitioning.h"
#import "UINavigationController+Transitioning.h"

@interface MNavigationTransitioning ()
@property (nonatomic, assign) NSTimeInterval animateTime;
@property (nonatomic, copy) void (^block)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) ;
@property (nonatomic, copy) void (^endBlock)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) ;

@end

@implementation MNavigationTransitioning


- (instancetype)initWithController:(UIViewController *) viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (NSTimeInterval) animateTime {
    if (_animateTime<=0.0) {
        return 0.35;
    }
    return _animateTime;
}

- (void) setEnable:(BOOL)enable {
    _enable = enable;
    if (_enable) {
        self.viewController.navigationController.delegate = self;
    } else {
        [self.viewController.navigationController resetNavigationDelegate];
    }
}

- (void) transitionWithPresenting:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) block
                              end:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) endBlock {
    self.block = block;
    self.endBlock = endBlock;
}

#pragma mark --UIViewControllerAnimatedTransitioning


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.animateTime;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    self.containerView = [transitionContext containerView];
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.fromView = self.fromVC.view;
    self.toView = self.toVC.view;
    self.toView.layer.masksToBounds = YES;
    self.fromView.layer.masksToBounds = YES;
    
    if ([self isPresenting]) {
        [self.containerView addSubview:self.fromView];
        [self.containerView addSubview:self.toView];
        !self.block?:self.block(transitionContext, self);
        
    } else {
        [self.containerView addSubview:self.toView];
        [self.containerView addSubview:self.fromView];
        !self.endBlock?:self.endBlock(transitionContext, self);
    }
}


#pragma mark --UINavigationControllerDelegate


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    self.presenting = (UINavigationControllerOperationPush == operation);
    return self.enable ? self : nil;
}

@end


@implementation MNavigationTransitioningModal

- (void (^)(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) block {
    __weak __typeof(self)weakSelf = self;
    CGSize size = self.containerView.bounds.size;
    self.toView.frame = CGRectMake(0, size.height, size.width, size.height);
    
    return ^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) {
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             self.toView.frame = CGRectMake(0, 0, size.width, size.height);
             
             
         }
                         completion:^(BOOL finished)
         {
             
             
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
             weakSelf.toView.userInteractionEnabled = YES;
         }];
    };
}

- (void (^)(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) endBlock {
    __weak __typeof(self)weakSelf = self;
    CGSize size = self.containerView.bounds.size;
    
    return ^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) {
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             weakSelf.fromView.frame = CGRectMake(0, size.height, size.width, size.height);
             
             
         }
                         completion:^(BOOL finished)
         {
             
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
             weakSelf.fromView.userInteractionEnabled = YES;
         }];
    };
}


@end


@implementation MNavigationTransitioningCenter

- (void (^)(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) block {
    __weak __typeof(self)weakSelf = self;
    CGSize size = self.containerView.bounds.size;

    self.toView.frame = self.originRect;
    
    return ^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) {
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             self.toView.frame = CGRectMake(0, 0, size.width, size.height);
             
             
         }
                         completion:^(BOOL finished)
         {
             
             
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
             weakSelf.toView.userInteractionEnabled = YES;
         }];
    };
}

- (void (^)(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) endBlock {
    __weak __typeof(self)weakSelf = self;
    
    return ^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) {
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             weakSelf.fromView.frame = weakSelf.originRect;
         }
                         completion:^(BOOL finished)
         {
             
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
             weakSelf.fromView.userInteractionEnabled = YES;
         }];
    };
}


@end
