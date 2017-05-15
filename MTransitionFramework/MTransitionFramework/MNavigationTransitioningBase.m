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

- (void)beginPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)endPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)prepareForClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)beginClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)endClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext
{
//    [self.fromView removeFromSuperview];
//    /**
//     ios8 bug? patch
//     work on both ios7 and ios8
//     **/
//    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self.toView]) {
//        if (self.toView.superview)
//            [self.toView removeFromSuperview];
//        [[[UIApplication sharedApplication] keyWindow] addSubview:self.toView];
//    }
//    
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
    

    if ([self isPresenting]) {
        [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.userInteractionEnabled = NO;
        [self.containerView addSubview:self.fromView];
        [self.containerView addSubview:self.toView];
        [self prepareForPresentingAnimations:transitionContext];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            [weakSelf beginPresentingAnimations:transitionContext];
        }
                         completion:^(BOOL finished)
        {
            [weakSelf endPresentingAnimations:transitionContext];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.userInteractionEnabled = YES;
        }];
        
    } else {
        [self prepareForClosingAnimations:transitionContext];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            [weakSelf beginClosingAnimations:transitionContext];
        }
                         completion:^(BOOL finished)
        {
            [weakSelf endClosingAnimations:transitionContext];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
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
                                                           toViewController:(UIViewController *)toVC
{
    return nil;
}
@end
