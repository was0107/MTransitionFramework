//
//  MNavigationTransitioning.h
//  testLeftPush
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationControllerDelegate.h"

@interface MNavigationTransitioning : MNavigationControllerDelegate<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;         //presenting or not
@property (nonatomic, weak) UIViewController  *viewController;   //releate controller
@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, assign) BOOL enable;


- (instancetype)initWithController:(UIViewController *) viewController;


/**
 Custom presenting animating or not

 @param block presenting block
 @param endBlock not presenting block
 */
- (void) transitionWithPresenting:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) block
                              end:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioning *trans)) endBlock;

@end


#pragma mark --
#pragma mark -- MNavigationTransitioningModal

/**
 Simulate modal presenting transition
 */
@interface MNavigationTransitioningModal : MNavigationTransitioning

@end

#pragma mark --
#pragma mark -- MNavigationTransitioningCenter

/**
 Transition from center
 */
@interface MNavigationTransitioningCenter : MNavigationTransitioning
@property (nonatomic, assign) CGRect originRect;
@end

