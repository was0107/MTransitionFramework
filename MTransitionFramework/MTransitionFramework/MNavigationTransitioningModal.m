//
//  MNavigationTransitioningModal.m
//  MTransitionFramework
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationTransitioningModal.h"

@interface MNavigationTransitioningModal()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *transitioning;


@end

@implementation MNavigationTransitioningModal
//
- (BOOL) isPresenting {
    return YES;
}
////
//
//#pragma mark --UIViewControllerAnimatedTransitioning
//
- (void) prepareForPresentingAnimations:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [super prepareForPresentingAnimations:transitionContext];
    CGSize size = self.containerSize;
    self.fromView.frame = CGRectMake(0, 0, size.width, size.height);
    self.toView.frame = CGRectMake(size.width, 0, size.width, size.height);
}

- (void)beginPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.fromView.frame = CGRectMake(-0.3 * self.containerSize.width, 0, self.containerSize.width, self.containerSize.height);
    self.toView.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void)endPresentingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.fromView.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}
//
//
//- (void)beginClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
////    CGSize size = self.containerSize;
////    self.fromView.frame = CGRectMake(0, size.height, size.width, size.height);
//
//}
//
//- (void)endClosingAnimations:(id <UIViewControllerContextTransitioning>)transitionContext {
//
//}
//
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    [super navigationController:navigationController willShowViewController:viewController animated:animated];
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    [super navigationController:navigationController didShowViewController:viewController animated:animated];
//    
//}
//
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController  {
    
    if ([animationController isKindOfClass:[MNavigationTransitioningModal class]]) {

        
        _transitioning = [[UIPercentDrivenInteractiveTransition alloc] init];
        _transitioning.completionCurve = UIViewAnimationCurveEaseInOut;
        [_transitioning finishInteractiveTransition];
        return _transitioning;
    }
    
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    self.presenting = (UINavigationControllerOperationPush == operation);
    return (UINavigationControllerOperationPush == operation)?self:nil;
}
@end
