//
//  MNavigationTransitioningBase.h
//  testLeftPush
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationControllerDelegate.h"

@interface MNavigationTransitioningBase : MNavigationControllerDelegate<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;     //presenting or not
@property (nonatomic, assign) IBOutlet UINavigationController  *navigationController;   //releate navigation controller

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, assign) CGSize containerSize;


- (instancetype)initWithNavigationController:(UINavigationController *) navigationController;


/**
 Presenting
 
 Note: this method has already implement adding fromView and toView to the containerView,so
 the subclass needs to call ```[super prepareForPresentingAnimations:transitionContext]``` before custom actions

 
 @param transitionContext transitionContext description
 */
- (void)prepareForPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext ;


/**
 deal with real animted block

 @param transitionContext transitionContext description
 */
- (void)beginPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext;


/**
 finish aniated block

 @param transitionContext transitionContext description
 */
- (void)endPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext;


/**
 Finish Presenting

 @param transitionContext transitionContext description
 */
- (void)prepareForClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext;


/**
 deal with real animted block
 
 @param transitionContext transitionContext description
 */
- (void)beginClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext;

/**
 finish aniated block
 
 @param transitionContext transitionContext description
 */
- (void)endClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext;
@end
