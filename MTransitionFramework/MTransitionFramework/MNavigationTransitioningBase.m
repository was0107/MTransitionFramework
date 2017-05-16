//
//  MNavigationTransitioningBase.m
//  testLeftPush
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationTransitioningBase.h"

@interface MNavigationTransitioningBase ()
@property (nonatomic, assign) NSTimeInterval animateTime;

@end

@implementation MNavigationTransitioningBase


- (instancetype)initWithNavigationController:(UINavigationController *) navigationController {
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
    }
    return self;
}

#pragma mark --
#pragma mark --Getter

- (NSTimeInterval) animateTime {
    if (_animateTime<=0.0) {
        return 0.35;
    }
    return _animateTime;
}


- (void)prepareForPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
}

- (void) doPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void) endPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)prepareForClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void) doClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)endClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext
{ 
}

#pragma mark --UIViewControllerAnimatedTransitioning


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.animateTime;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    __weak __typeof(self)weakSelf = self;
    
    self.containerView = [transitionContext containerView];
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.fromView = self.fromVC.view;
    self.toView = self.toVC.view;
    self.containerSize = self.containerView.bounds.size;
    
    self.toView.layer.masksToBounds = YES;
    self.fromView.layer.masksToBounds = YES;
    
    if ([self isPresenting]) {
        self.toView.userInteractionEnabled = NO;
        [self.containerView addSubview:self.fromView];
        [self.containerView addSubview:self.toView];
        [self prepareForPresentingAnimations:transitionContext];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            [weakSelf doPresentingAnimations:transitionContext];
        }
                         completion:^(BOOL finished)
        {
            [weakSelf endPresentingAnimations:transitionContext];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            weakSelf.toView.userInteractionEnabled = YES;
        }];
        
    } else {
        [self.containerView addSubview:self.toView];
        [self.containerView addSubview:self.fromView];
        
        [self prepareForClosingAnimations:transitionContext];
        self.fromView.userInteractionEnabled = NO;
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            [weakSelf doClosingAnimations:transitionContext];
        }
                         completion:^(BOOL finished)
        {
            [weakSelf endClosingAnimations:transitionContext];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            weakSelf.fromView.userInteractionEnabled = YES;
        }];
    }
}


#pragma mark --UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super navigationController:navigationController willShowViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super navigationController:navigationController didShowViewController:viewController animated:animated];
}


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController  {
    
    
    return nil;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    self.presenting = (UINavigationControllerOperationPush == operation);
    return self.enable ? self : nil;
}

@end
