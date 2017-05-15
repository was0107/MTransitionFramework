//
//  UINavigationController+LeftPushTransitioning.h
//  testLeftPush
//
//  Created by Micker on 2017/5/12.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNavigationTransitioningLeftPush.h"
#import "MNavigationControllerDelegate.h"

@interface UINavigationController (Transitioning)
@property (nonatomic, strong) MNavigationControllerDelegate *navigationControllerDelegate;

- (void) resetNavigationDelegate;

@end
