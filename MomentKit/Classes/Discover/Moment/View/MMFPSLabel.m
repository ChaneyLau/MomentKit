//
//  MMFPSLabel.m
//  MomentKit
//
//  Created by LEA on 2019/3/25.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MMFPSLabel.h"

@interface MMFPSLabel ()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation MMFPSLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15.0];
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 8.0;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];

        // 拖动手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [self addGestureRecognizer:panGesture];
        
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)tick:(CADisplayLink *)link
{
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    _count ++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) {
        return;
    }
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    [attText addAttribute:NSForegroundColorAttributeName value:kHLTextColor range:NSMakeRange(0, attText.length - 3)];
    [attText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(0, attText.length - 3)];
    self.attributedText = attText;
}

- (void)changePostion:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    CGRect rect = [self updateFrame:self.frame point:point];
    self.frame = rect;
    
    [pan setTranslation:CGPointZero inView:self];
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGRect frame = self.frame;
        if (self.center.x <= k_screen_width / 2.0){
            frame.origin.x = 0;
        } else {
            frame.origin.x = k_screen_width - frame.size.width;
        }
        if (frame.origin.y < 20) {
            frame.origin.y = 20;
        } else if (frame.origin.y + frame.size.height > k_screen_height) {
            frame.origin.y = k_screen_height - frame.size.height;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
    }
}

- (CGRect)updateFrame:(CGRect)frame point:(CGPoint)point
{
    // x值
    BOOL condition1 = frame.origin.x >= 0;
    BOOL condition2 = frame.origin.x + frame.size.width <= k_screen_width;
    if (condition1 && condition2) {
        frame.origin.x += point.x;
    }
    // y值
    condition1 = frame.origin.y >= 20;
    condition2 = frame.origin.y + frame.size.height <= k_screen_height;
    if (condition1 && condition2) {
        frame.origin.y += point.y;
    }
    return frame;
}

- (void)dealloc
{
    [_link invalidate];
    _link = nil;
}

@end
