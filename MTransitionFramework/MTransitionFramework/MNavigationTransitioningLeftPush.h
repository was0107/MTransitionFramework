//
//  MNavigationTransitioningLeftPush.h
//  testLeftPush
//
//  Created by Micker on 2017/5/11.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNavigationTransitioningBase.h"

@protocol MNavigationTransitioningLeftPushDelegate <NSObject>

/**
 Can reposne to the left in gesture

 @return YES，in ，NO
 */
- (BOOL) canResponseToNavigationLeftPush;


/**
 response to left in gesture, in this method ,you should push viewcontroller like this ,
 the animated parameter must be YES;
 
 ```
 DemoViewController *controller = [[DemoViewController alloc] init];
 [self.navigationController pushViewController:controller animated:YES];
 
 ```
 */
- (void) responseToNavigationLeftPush;

@end


/**
 This class only response to left in modal
 
 note： while using this class , it may conflict with the back gesture;
 isPresenting always return YES
 */
@interface MNavigationTransitioningLeftPush : MNavigationTransitioningBase<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *leftPushPanGesture;     //left push in gesture
@property (nonatomic, weak) id<MNavigationTransitioningLeftPushDelegate> delegate;

@end
