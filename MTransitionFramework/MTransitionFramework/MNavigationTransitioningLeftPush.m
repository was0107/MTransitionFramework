//
//  MNavigationTransitioningLeftPush.m
//  testLeftPush
//
//  Created by Micker on 2017/5/11.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationTransitioningLeftPush.h"
#import "UINavigationController+Transitioning.h"
#import "MNavigationTransitioning.h"

static CGFloat gTransionShadowWidth = 6.0f;

@interface MNavigationTransitioningLeftPush()

@property (nonatomic, strong) UIPanGestureRecognizer *leftPushPanGesture;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *transitioning;
@property (nonatomic, assign) BOOL isGesturePush;

@end

@implementation MNavigationTransitioningLeftPush

- (BOOL) isPresenting {
    return YES;
}

- (void (^)(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) block {
    __weak __typeof(self)weakSelf = self;
    CGSize size = self.containerView.bounds.size;
    weakSelf.toView.userInteractionEnabled = NO;
    
    UIView *shadowView = [self.containerView viewWithTag:20170605];
    
    if (!shadowView) {
        shadowView = [[UIView alloc] initWithFrame:self.toView.bounds];
        shadowView.tag = 20170605;
        shadowView.backgroundColor = self.toView.backgroundColor;
        shadowView.layer.shadowOffset = CGSizeMake(-gTransionShadowWidth, 0);
        shadowView.layer.shadowRadius = gTransionShadowWidth;
        shadowView.layer.shadowOpacity = 0.4f;
        shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
        shadowView.layer.shadowColor = [UIColor colorWithWhite:.0f alpha:0.5f].CGColor;
        [self.containerView insertSubview:shadowView belowSubview:self.toView];
    }
    
    shadowView.frame = self.toView.frame = CGRectMake(size.width, 0, size.width, size.height);

    return ^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) {
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             weakSelf.fromView.frame = CGRectMake(-0.3 * size.width, 0, size.width, size.height);
             shadowView.frame = weakSelf.toView.frame = CGRectMake(0, 0, size.width, size.height);
         }
                         completion:^(BOOL finished)
         {
             
             weakSelf.fromView.frame = CGRectMake(0, 0, size.width, size.height);
             [shadowView removeFromSuperview];
             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
             weakSelf.toView.userInteractionEnabled = YES;
         }];
    };
}

#pragma mark - gesture

- (void)setViewController:(UIViewController *)viewController {
    [super setViewController:viewController];
    [viewController.view addGestureRecognizer:self.leftPushPanGesture];
}

- (UIPanGestureRecognizer *)leftPushPanGesture {
    if (!_leftPushPanGesture) {
        UIPanGestureRecognizer *pushGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleLeftPushRecognizer:)];
        _leftPushPanGesture = pushGesture;
        [_leftPushPanGesture requireGestureRecognizerToFail:self.viewController.navigationController.interactivePopGestureRecognizer];
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
    
    self.enable = YES;
    
    CGFloat progress = [recognizer translationInView:self.viewController.view].x / (self.viewController.view.bounds.size.width);

    BOOL canLeftPush = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(canResponseToNavigationLeftPush)]) {
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


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController  {
    
    if (self.enable && self.isGesturePush && [animationController isKindOfClass:[MNavigationTransitioningLeftPush class]]) {
        return _transitioning;
    }

    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    BOOL flag = (self.enable && self.isGesturePush && UINavigationControllerOperationPush == operation);
    return flag ? self : nil;
}
@end
