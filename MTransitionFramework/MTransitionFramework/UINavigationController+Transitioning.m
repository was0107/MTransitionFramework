//
//  UINavigationController+Transitioning.m
//  testLeftPush
//
//  Created by Micker on 2017/5/12.
//  Copyright © 2017年 WSCN. All rights reserved.
//

#import "UINavigationController+Transitioning.h"
#import <objc/runtime.h>

@implementation UINavigationController (Transitioning)

@dynamic navigationControllerDelegate;

- (MNavigationControllerDelegate *) navigationControllerDelegate {
    MNavigationControllerDelegate *_navigationControllerDelegate = objc_getAssociatedObject(self, _cmd);
    if (!_navigationControllerDelegate) {
        _navigationControllerDelegate = [[MNavigationControllerDelegate alloc] init];
        objc_setAssociatedObject(self, _cmd, _navigationControllerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _navigationControllerDelegate;
}

- (void) setNavigationControllerDelegate:(MNavigationControllerDelegate *)navigationControllerDelegate {
    objc_setAssociatedObject(self, @selector(navigationControllerDelegate), navigationControllerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) resetNavigationDelegate {
    self.delegate = self.navigationControllerDelegate;
}

@end
