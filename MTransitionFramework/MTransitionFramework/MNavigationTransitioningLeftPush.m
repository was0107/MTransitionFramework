//
//  MNavigationTransitioningLeftPush.m
//  testLeftPush
//
//  Created by Micker on 2017/5/11.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationTransitioningLeftPush.h"
#import "UINavigationController+Transitioning.h"

@interface MNavigationTransitioningLeftPush()

@property (nonatomic, strong) UIPanGestureRecognizer *leftPushPanGesture;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *transitioning;
@property (nonatomic, assign) BOOL isGesturePush;

@end

@implementation MNavigationTransitioningLeftPush


- (BOOL) isPresenting {
    return YES;
}

- (void) setDelegate:(id<MNavigationTransitioningLeftPushDelegate>)delegate {
    _delegate = delegate;
    self.leftPushPanGesture.enabled = _delegate?YES:NO;
    if (_delegate) {
        self.navigationController.delegate = self;
    } else {
        [self.navigationController resetNavigationDelegate];
    }
}

- (void) dealloc {
}

#pragma mark --UIViewControllerAnimatedTransitioning

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


#pragma mark - gesture

- (void)setNavigationController:(UINavigationController *)navigationController{
    [super setNavigationController:navigationController];
    [navigationController.view addGestureRecognizer:self.leftPushPanGesture];
}

- (UIPanGestureRecognizer *)leftPushPanGesture {
    if (!_leftPushPanGesture) {
        UIScreenEdgePanGestureRecognizer *pushGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(handleLeftPushRecognizer:)];
        pushGesture.edges = UIRectEdgeRight;
        _leftPushPanGesture = pushGesture;
        [_leftPushPanGesture requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    return _leftPushPanGesture;
}

- (void)handleLeftPushRecognizer:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint translation = [recognizer velocityInView:recognizer.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.isGesturePush = translation.x<0 ? YES : NO;
    }
    if (!self.isGesturePush) {
        return;
    }
    
    CGFloat progress = [recognizer translationInView:self.navigationController.view].x / (self.navigationController.view.bounds.size.width);

    BOOL canLeftPush = NO;
    if (!self.delegate || [self.delegate respondsToSelector:@selector(canResponseToNavigationLeftPush)]) {
        canLeftPush = [self.delegate canResponseToNavigationLeftPush];
    }
    if (!canLeftPush) {
        return;
    }

    progress = MIN(1.0, MAX(0.0, -progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(responseToNavigationLeftPush)]) {
            _transitioning = [[UIPercentDrivenInteractiveTransition alloc] init];
            _transitioning.completionCurve = UIViewAnimationCurveEaseInOut;
            [self.delegate responseToNavigationLeftPush];
            [_transitioning updateInteractiveTransition:0];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [_transitioning updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (progress > 0.25) {
            [_transitioning finishInteractiveTransition];
        }
        else {
            [_transitioning cancelInteractiveTransition];
        }
        
        self.isGesturePush = NO;
        _transitioning = nil;
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
    
    if (self.isGesturePush && [animationController isKindOfClass:[MNavigationTransitioningLeftPush class]]) {
        return _transitioning;
    }

    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    BOOL flag = (self.isGesturePush && UINavigationControllerOperationPush == operation);
    return flag ? self : nil;
}
@end
