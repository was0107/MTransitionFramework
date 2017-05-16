//
//  MNavigationTransitioningModal.h
//  MTransitionFramework
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "MNavigationTransitioningLeftPush.h"


/**
 Simulate modal presenting transition
 */
@interface MNavigationTransitioningModal : MNavigationTransitioningBase<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

@end

#pragma mark --
#pragma mark -- MNavigationTransitioningCenter

/**
 Transition from center
 */
@interface MNavigationTransitioningCenter : MNavigationTransitioningBase<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>
@property (nonatomic, assign) CGRect originRect;
@end


#pragma mark --
#pragma mark -- MNavigationTransitioningCustom

/**
 Custom transition
 */
@interface MNavigationTransitioningCustom : MNavigationTransitioningBase<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

- (void) transitionWithPresenting:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioningBase *trans)) block
                              end:(void (^)(id <UIViewControllerContextTransitioning> transitionContext, MNavigationTransitioningBase *trans)) endBlock;
@end






