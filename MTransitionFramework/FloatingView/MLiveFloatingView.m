//
//  MLiveFloatingView.m
//  MNewsDetailFramework
//
//  Created by Micker on 2020/6/29.
//  Copyright © 2020 Micker. All rights reserved.
//

#import "MLiveFloatingView.h"
@interface MLiveFloatingView()
@property (nonatomic, strong) CAShapeLayer *contentLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *barLayer;
@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) CAReplicatorLayer *replicatedLayer;
@end

@implementation MLiveFloatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        CGFloat height = CGRectGetHeight(frame);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(height/2, height/2)];

        CAShapeLayer *contentLayer = [[CAShapeLayer alloc] init];
        contentLayer.frame = self.bounds;
        contentLayer.fillColor = [UIColor lightGrayColor].CGColor;
        contentLayer.path = path.CGPath;
        self.contentLayer = contentLayer;
        [self.layer addSublayer:contentLayer];
        
        
        self.circleLayer.frame = CGRectMake(3,3,height-6,height-6);
        CGRect rect = CGRectMake(0, 0, height-6, height-6);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect  cornerRadius:height/2-2];
        self.circleLayer.path = maskPath.CGPath;
        [self.layer addSublayer:self.circleLayer];
        
        self.barLayer.fillColor = [UIColor redColor].CGColor;
        self.barLayer.frame = CGRectMake(2,2,4,height/2-4);
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.barLayer.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2,2)];
        self.barLayer.path = maskPath.CGPath;
        
        self.replicatedLayer.frame = CGRectMake(height/6, 10,height-4,height/2-2);
        [self.layer addSublayer:self.replicatedLayer];

        
        self.textLayer.frame = CGRectMake(height + 4,height/2 - 8,CGRectGetWidth(frame) - height,16);
        [self.layer addSublayer:self.textLayer];
    }
    return self;
}

- (CAShapeLayer *) circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer new];
        _circleLayer.fillColor = [UIColor whiteColor].CGColor;
    }
    return _circleLayer;
}

- (CAShapeLayer *) barLayer {
    if (!_barLayer) {
        _barLayer = [CAShapeLayer new];
        _barLayer.fillColor = [UIColor redColor].CGColor;
        _barLayer.anchorPoint = CGPointMake(0, 1);
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.keyPath = @"transform.scale.y";
        basicAnimation.toValue = @0.1;
        basicAnimation.repeatCount = MAXFLOAT;
        basicAnimation.duration = 0.3;
        basicAnimation.autoreverses = YES;
        basicAnimation.removedOnCompletion = NO;
        [_barLayer addAnimation:basicAnimation forKey:nil];
    }
    return _barLayer;
}

- (CAReplicatorLayer *) replicatedLayer {
    if (!_replicatedLayer) {
        _replicatedLayer = [CAReplicatorLayer new];
        _replicatedLayer.instanceCount = 3;
        _replicatedLayer.instanceDelay = 0.09;
        _replicatedLayer.instanceTransform = CATransform3DMakeTranslation(9, 0, 0);
        [_replicatedLayer addSublayer:self.barLayer];
    }
    return _replicatedLayer;
}

- (CATextLayer *) textLayer {
    if (!_textLayer) {
        _textLayer = [CATextLayer new];
        _textLayer.string = @"直播中";
        _textLayer.fontSize = 13;
        _textLayer.alignmentMode = kCAAlignmentLeft;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _textLayer;
}

- (void) configData:(NSDictionary *) data {
    
}

@end
