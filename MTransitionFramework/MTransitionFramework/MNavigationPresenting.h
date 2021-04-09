//
//  MNavigationPresenting.h
//  MTransitionFramework
//
//  Created by Micker on 2021/4/8.
//  Copyright © 2021 WSCN. All rights reserved.
//

#import "MNavigationTransitioning.h"

@interface MNavigationPresenting : MNavigationTransitioning<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat heightRatio;
@property (nonatomic, copy) void (^backViewTapedBlock)();
@property (nonatomic, copy) void (^completeTransitionBlock)();

@end
