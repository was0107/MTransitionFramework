//
//  ViewController.h
//  DemoTransition
//
//  Created by Micker on 2017/5/15.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNavigationTransitioning.h"

@interface BaseViewController : UIViewController
@property (nonatomic, strong) MNavigationTransitioning *navigationTransitioning;
@property (nonatomic, weak) UIViewController *parenetController;

@end



@interface LeftPushViewController : BaseViewController

@end


@interface CenterViewController : BaseViewController

@end


@interface ModalViewController : BaseViewController

@end


@interface CustomViewController : BaseViewController

@end
