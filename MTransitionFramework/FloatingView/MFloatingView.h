//
//  MFloatingView.h
//  MNewsDetailFramework
//
//  Created by Micker on 2020/6/29.
//  Copyright © 2020 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MFloatingTouchType) {
    MFloatingTouchTypeBegan = 0,
    MFloatingTouchTypeMoved,
    MFloatingTouchTypeEnded,
    MFloatingTouchTypeCancelled
};

typedef NS_ENUM(NSUInteger, MFloatingMovingDirectionType) {
    MFloatingMovingDirectionXAxis   = 1<<0,         // only move at x axis direction
    MFloatingMovingDirectionYAxis   = 1<<1,         // only move at y asix direction
    MFloatingMovingDirectionAll     = (MFloatingMovingDirectionXAxis | MFloatingMovingDirectionYAxis),  // move all direction, this is the default value
};

typedef NS_ENUM(NSUInteger, MFloatingStopPosition) {
    MFloatingStopPositionLeft       = 1<<0,         // stop at left when release dragging
    MFloatingStopPositionRight      = 1<<1,         // stop at right when release dragging
    MFloatingStopPositionTop        = 1<<2,         // stop at top when release dragging
    MFloatingStopPositionBottom     = 1<<3,         // stop at bottom when release dragging
    MFloatingStopPositionHoriontal  = (MFloatingStopPositionLeft | MFloatingStopPositionRight), // stop horiontal when release dragging, this is the default value
    MFloatingStopPositionVertical   = (MFloatingStopPositionTop | MFloatingStopPositionBottom), // stop vertical when release dragging
    MFloatingStopPositionAll        = (MFloatingStopPositionHoriontal | MFloatingStopPositionVertical), // stop all postion when release dragging
};


/// a custom floating view
@interface MFloatingView : UIControl

/// touchstate, 0:began, 1:moved, 2:ended,3:cancelled
/// only works on enableMove is YES
@property (nonatomic, copy) void (^touchBlock)(MFloatingTouchType touchState, NSSet *touches, UIEvent *event);

/// single tap gesture action block, once set , MFloatingView will addgesture internal
@property (nonatomic, copy) void (^singleTapBlock)();

/// double tap gesture action block, once set , MFloatingView will addgesture internal
@property (nonatomic, copy) void (^doubleTapBlock)();

/// allow to move
@property (nonatomic) BOOL enableMove;  // default is YES

@property (nonatomic) CGFloat movingAlpha;  //  default is 0.5

@property (nonatomic) CGFloat movingScale;  //  default is 1.1

@property (nonatomic) CGFloat animationTime;    //default is 0.35

@property (nonatomic) MFloatingMovingDirectionType direction;   //default is MFloatingMovingDirectionAll

@property (nonatomic) MFloatingStopPosition stopPosition;   //default is MFloatingStopPositionHoriontal

@property (nonatomic) UIEdgeInsets disableEdgeInsets;   // default is UIEdgeInsetsZero


/// rerange frame with all special values
/// @param animation animation description , animatable
- (void) layoutSubviewsWithAnimation:(BOOL) animation;

@end

NS_ASSUME_NONNULL_END
