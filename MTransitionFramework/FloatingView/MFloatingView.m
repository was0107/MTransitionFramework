//
//  MFloatingView.m
//  MNewsDetailFramework
//
//  Created by Micker on 2020/6/29.
//  Copyright © 2020 Micker. All rights reserved.
//

#import "MFloatingView.h"

@interface MFloatingView()
@property (nonatomic) BOOL isTrackMoving;
@property (nonatomic, assign) CGPoint beginpoint;
@end

@implementation MFloatingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configInitialData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configInitialData];
    }
    return self;
}

- (void) configInitialData {
    _disableEdgeInsets = UIEdgeInsetsZero;
    _stopPosition = MFloatingStopPositionHoriontal;
    _direction = MFloatingMovingDirectionAll;
    _movingAlpha = 0.5;
    _movingScale = 1.03;
    _animationTime = 0.35;
    self.userInteractionEnabled = YES;
}

- (void) didMoveToSuperview {
    [super didMoveToSuperview];
    [self layoutSubviewsWithAnimation:NO];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self layoutSubviewsWithAnimation:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _isTrackMoving = NO;
    [super touchesBegan:touches withEvent:event];
    if (!_enableMove) {
        return;
    }
    UITouch *touch = [touches anyObject];
    _beginpoint = [touch locationInView:self];
    !self.touchBlock?:self.touchBlock(MFloatingTouchTypeBegan,touches,event);
    self.alpha = self.movingAlpha;
    self.transform = CGAffineTransformScale(self.transform,self.movingScale,self.movingScale);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (!_enableMove) {
        return;
    }
    _isTrackMoving = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    
    CGFloat x = self.center.x + currentPosition.x - _beginpoint.x;
    CGFloat y = self.center.y + currentPosition.y - _beginpoint.y;
    
    if (x > (self.superview.frame.size.width-self.frame.size.width/2 - self.disableEdgeInsets.right)) {
        x = self.superview.frame.size.width-self.frame.size.width/2 - self.disableEdgeInsets.right;
    }else if (x < (self.frame.size.width/2 + self.disableEdgeInsets.left)){
        x = self.frame.size.width/2 + self.disableEdgeInsets.left;
    }
    
    if (y > (self.superview.frame.size.height-self.frame.size.height/2 - self.disableEdgeInsets.bottom)) {
        y = self.superview.frame.size.height-self.frame.size.height/2 - self.disableEdgeInsets.bottom;
    }else if (y <= (self.frame.size.height/2 + self.disableEdgeInsets.top)){
        y = self.frame.size.height/2 + self.disableEdgeInsets.top;
    }
    
    if (MFloatingMovingDirectionXAxis != (MFloatingMovingDirectionXAxis & self.direction)) {
        x = self.center.x;
    }
    else if (MFloatingMovingDirectionYAxis != (MFloatingMovingDirectionYAxis & self.direction)) {
        y = self.center.y;
    }
    self.center = CGPointMake(x, y);
    !self.touchBlock?:self.touchBlock(MFloatingTouchTypeMoved,touches,event);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enableMove) {
        return;
    }
    [self layoutSubviewsWithAnimation:YES];
    [super touchesEnded: touches withEvent: event];
    !self.touchBlock?:self.touchBlock(MFloatingTouchTypeEnded,touches,event);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self layoutSubviewsWithAnimation:YES];
    [super touchesCancelled:touches withEvent:event];
    !self.touchBlock?:self.touchBlock(MFloatingTouchTypeCancelled,touches,event);
}

#pragma mark --setter

- (void) setDisableEdgeInsets:(UIEdgeInsets)disableEdgeInsets {
    _disableEdgeInsets = disableEdgeInsets;
    [self layoutSubviewsWithAnimation:NO];
}

- (void) setStopPosition:(MFloatingStopPosition)stopPosition {
    _stopPosition = stopPosition;
    [self layoutSubviewsWithAnimation:NO];
}

- (void) setAnimationTime:(CGFloat)animationTime {
    if (animationTime >= 0) {
        _animationTime = animationTime;
    }
}

- (void) setSingleTapBlock:(void (^)())singleTapBlock {
    _singleTapBlock = [singleTapBlock copy];
    {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__singleTapGesture:)];
        [self addGestureRecognizer:recognizer];
    }
}

- (void) setDoubleTapBlock:(void (^)())doubleTapBlock {
    _doubleTapBlock = [doubleTapBlock copy];
    {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__doubleTapGesture:)];
        recognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:recognizer];
    }
}


#pragma mark --action

- (void) __singleTapGesture:(UIGestureRecognizer *) recognizer {
    !_singleTapBlock?:_singleTapBlock();
}

- (void) __doubleTapGesture:(UIGestureRecognizer *) recognizer {
    !_doubleTapBlock?:_doubleTapBlock();
}

- (BOOL) checkForPosition:(MFloatingStopPosition) positoin {
    return positoin == (positoin & self.stopPosition);
}

- (void) layoutSubviewsWithAnimation:(BOOL) animation {
    if (self.superview) {
        CGRect frame = self.frame;
        CGSize superSize = self.superview.frame.size;
        CGPoint origin = frame.origin;
        if ([self checkForPosition:MFloatingStopPositionAll] ) {
            CGFloat left = CGRectGetMinX(frame);
            CGFloat right = superSize.width - CGRectGetMaxX(frame);
            CGFloat top = CGRectGetMinY(frame);
            CGFloat bottom = superSize.height - CGRectGetMaxY(frame);
            CGFloat min = MIN(MIN(left,right),MIN(top,bottom));
            if (left == min) {
                origin.x = self.disableEdgeInsets.left;
            }
            else if(right == min) {
                origin.x = superSize.width - frame.size.width - self.disableEdgeInsets.right;
            }
            else if(top == min) {
                origin.y = self.disableEdgeInsets.top;
            }
            else if(bottom == min) {
                origin.y = superSize.height - frame.size.height - self.disableEdgeInsets.bottom;
            }
        }
        else if ([self checkForPosition:MFloatingStopPositionHoriontal] ) {
            if (self.center.x < superSize.width/2) {
                origin.x = self.disableEdgeInsets.left;
            } else {
                origin.x = superSize.width - frame.size.width - self.disableEdgeInsets.right;
            }
        }
        else if ([self checkForPosition:MFloatingStopPositionVertical]) {
            if (self.center.y < superSize.height/2) {
                origin.y = self.disableEdgeInsets.top;
            } else {
                origin.y = superSize.height - frame.size.height - self.disableEdgeInsets.bottom;
            }
        }
        else if ([self checkForPosition:MFloatingStopPositionLeft]) {
            origin.x = self.disableEdgeInsets.left;
        }
        else if ([self checkForPosition:MFloatingStopPositionRight]) {
            origin.x = superSize.width - frame.size.width - self.disableEdgeInsets.right;
        }
        else if ([self checkForPosition:MFloatingStopPositionTop]) {
            origin.y = self.disableEdgeInsets.top;
        }
        else if ([self checkForPosition:MFloatingStopPositionBottom]) {
            origin.y = superSize.height - frame.size.height - self.disableEdgeInsets.bottom;
        }
        frame.origin = origin;
        [UIView animateWithDuration:animation?0:self.animationTime
                         animations:^{
            self.frame = frame;
            self.alpha = 1;
            self.transform = CGAffineTransformIdentity;
        }];
    }
}


@end
