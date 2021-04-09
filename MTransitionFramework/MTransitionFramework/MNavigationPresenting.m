//
//  MNavigationPresenting.m
//  MTransitionFramework
//
//  Created by Micker on 2021/4/8.
//  Copyright © 2021 WSCN. All rights reserved.
//

#import "MNavigationPresenting.h"

@interface MNavigationPresenting()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *transitioning;

@end

@implementation MNavigationPresenting {
    CGFloat _scrollViewBeginContentOffsetY;
}

- (void) transitionEnable {
   
}

- (CGFloat) heightRatio {
    if (_heightRatio <= 0) {
        _heightRatio = 0.7;
    }
    return _heightRatio;
}

- (void (^)(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) block {
    
    __weak __typeof(self)weakSelf = self;
    return ^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)
    {
        
        CGSize size = trans.containerView.bounds.size;
        trans.toView.frame = CGRectMake(0, size.height, size.width, size.height * self.heightRatio);
        
        UIView *snapView = [trans.fromView snapshotViewAfterScreenUpdates:NO];
        snapView.tag = 20210408;
        snapView.frame = self.containerView.frame;
        [trans.containerView insertSubview:snapView belowSubview:trans.toView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.containerView.frame];
        bgView.tag = 20210409;
        bgView.alpha = 0;
        bgView.backgroundColor = [UIColor blackColor];
        [trans.containerView insertSubview:bgView belowSubview:trans.toView];
        
        [bgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapAction:)]];
        trans.fromView.hidden = YES;

         [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
             bgView.alpha = 0.4;
             trans.toView.frame = CGRectMake(0, size.height * (1 - weakSelf.heightRatio), size.width, size.height * weakSelf.heightRatio);

         }
                         completion:^(BOOL finished)
         {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            if ([transitionContext transitionWasCancelled]) {
                trans.fromView.hidden = NO;
                [snapView removeFromSuperview];
                [bgView removeFromSuperview];
            }
         }];
    };
}

- (void (^)(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) endBlock {
    __weak __typeof(self)weakSelf = self;
    return ^(id<UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans) {
        
        CGRect transFrame = trans.containerView.frame;
        __block UIView *snapView = [trans.containerView viewWithTag:20210408];
        __block UIView *bgView = [trans.containerView viewWithTag:20210409];
        [UIView animateWithDuration:[trans transitionDuration:transitionContext]
                         animations:^
         {
            bgView.alpha = 0;
            trans.fromView.frame = CGRectMake(0, CGRectGetHeight(transFrame), CGRectGetWidth(transFrame), CGRectGetHeight(transFrame));
         }
                         completion:^(BOOL finished)
         {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            if (![transitionContext transitionWasCancelled]) {
                trans.toView.hidden = NO;
                [snapView removeFromSuperview];
                snapView = nil;
                [bgView removeFromSuperview];
                bgView = nil;
                !weakSelf.completeTransitionBlock?:weakSelf.completeTransitionBlock();
            }
         }];
    };
}

- (void) backgroundTapAction:(UIGestureRecognizer *) recognizer {
    !self.backViewTapedBlock?:self.backViewTapedBlock();
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePanRecognizer:)];
        [_panGesture requireGestureRecognizerToFail:self.viewController.navigationController.interactivePopGestureRecognizer];
    }
    return _panGesture;
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer*)recognizer {
    CGFloat progress = MIN(1.0, MAX(0.0, ([recognizer translationInView:recognizer.view].y - _scrollViewBeginContentOffsetY) / CGRectGetHeight(recognizer.view.bounds)));
    
    UIScrollView *scrollView;
    if ([recognizer.view isKindOfClass: [UIScrollView class]]) {
        scrollView = (UIScrollView *)recognizer.view;
        if (scrollView.contentOffset.y <= 0 || (_transitioning && progress > 0)) {
            [scrollView setContentOffset:CGPointZero];
        }
    }
    NSLog(@"progress = %.2f",progress);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _transitioning = [[UIPercentDrivenInteractiveTransition alloc] init];
            _transitioning.completionCurve = UIViewAnimationCurveEaseOut;
            [_transitioning updateInteractiveTransition:0];
            [self backgroundTapAction:nil];
            _scrollViewBeginContentOffsetY = scrollView.contentOffset.y;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [_transitioning updateInteractiveTransition:progress];
        }
            break;
            
        default:
        {
            if (progress > 0.25) {
                [_transitioning finishInteractiveTransition];
            }
            else {
                [_transitioning cancelInteractiveTransition];
            }
            _scrollViewBeginContentOffsetY = 0;
            _transitioning = nil;
        }
            break;
    }
}



#pragma mark -- UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source
{
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.transitioning;
}

@end
