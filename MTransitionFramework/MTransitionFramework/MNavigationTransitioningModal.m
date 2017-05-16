//
//  MNavigationTransitioningModal.m
//  MTransitionFramework
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationTransitioningModal.h"

@implementation MNavigationTransitioningModal

#pragma mark --UIViewControllerAnimatedTransitioning

- (void) prepareForPresentingAnimations:(id<UIViewControllerContextTransitioning>)transitionContext {
    CGSize size = self.containerSize;
    self.toView.frame = CGRectMake(0, size.height, size.width, size.height);
}

- (void) doPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.toView.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void) endPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.fromView.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void) doClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    CGSize size = self.containerSize;
    self.fromView.frame = CGRectMake(0, size.height, size.width, size.height);
}

@end

#pragma mark --
#pragma mark -- MNavigationTransitioningCenter

@implementation MNavigationTransitioningCenter

#pragma mark --UIViewControllerAnimatedTransitioning

- (void) prepareForPresentingAnimations:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.toView.frame = self.originRect;
}

- (void) doPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.toView.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void) endPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.fromView.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void) doClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.fromView.frame = self.originRect;
}

@end

#pragma mark --
#pragma mark -- MNavigationTransitioningCustom

@interface MNavigationTransitioningCustom ()
@property (nonatomic, copy) void (^block)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioningBase *trans) ;
@property (nonatomic, copy) void (^endBlock)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioningBase *trans) ;

@end

@implementation MNavigationTransitioningCustom


- (void) transitionWithPresenting:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioningBase *trans)) block
                              end:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioningBase *trans)) endBlock {
    self.block = block;
    self.endBlock = endBlock;
}

#pragma mark --UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    self.containerView = [transitionContext containerView];
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.fromView = self.fromVC.view;
    self.toView = self.toVC.view;
    self.containerSize = self.containerView.bounds.size;
    
    if ([self isPresenting]) {
        [self.containerView addSubview:self.fromView];
        [self.containerView addSubview:self.toView];
        !self.block?:self.block(transitionContext, self);
        
    } else {
        !self.endBlock?:self.endBlock(transitionContext, self);
    }
}

@end


