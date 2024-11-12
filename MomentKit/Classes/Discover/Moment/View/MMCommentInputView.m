//
//  MMCommentInputView.m
//  MomentKit
//
//  Created by LEA on 2019/3/25.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MMCommentInputView.h"
#import <YYText.h>

@interface MMCommentInputView () <YYTextViewDelegate>

// 容器视图
@property (nonatomic, strong) UIView *containView;
// 输入框
@property (nonatomic, strong) YYTextView *textView;
// 表情按钮
@property (nonatomic, strong) UIButton *emoticonBtn;
// 记录容器高度
@property (nonatomic, assign) CGFloat ctHeight;
// 记录上一次容器高度
@property (nonatomic, assign) CGFloat previousCtHeight;
// 键盘高度
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation MMCommentInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        // 容器视图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, k_screen_height, k_screen_width, MMContainMinHeight)];
        view.backgroundColor = MMRGBColor(248, 248, 248);
        [self addSubview:view];
        self.containView = view;
        // -- 分割线
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = MMRGBColor(230, 230, 230).CGColor;
        layer.frame = CGRectMake(0, 0, k_screen_width, 0.5);
        [view.layer addSublayer:layer];
        
        // 行间距
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        // attributes
        NSDictionary *textAttributes = @{NSParagraphStyleAttributeName:style};
        // 输入框
        YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(15, MarginHeight/2.0, k_screen_width - (MMContainMinHeight + 15), MMContainMinHeight - MarginHeight)];
        textView.backgroundColor = [UIColor whiteColor];
        textView.returnKeyType = UIReturnKeySend;
        textView.enablesReturnKeyAutomatically = YES;
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        textView.layer.cornerRadius = 4;
        textView.layer.masksToBounds = YES;
        textView.delegate = self;
        textView.textColor = [UIColor blackColor];
        textView.font = [UIFont systemFontOfSize:16.0];
        textView.textContainerInset = UIEdgeInsetsMake(7, 7, 7, 7);
        textView.typingAttributes = textAttributes;
        textView.placeholderText = @"发表评论：";
        textView.placeholderTextColor = MMRGBColor(220, 220, 220);
        textView.delegate = self;
        [self.containView addSubview:textView];
        self.textView = textView;
        
        // 表情按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(k_screen_width - MMContainMinHeight, 0, MMContainMinHeight, MMContainMinHeight)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [btn setImage:[UIImage imageNamed:@"moment_emoticon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"moment_emoticon_hl"] forState:UIControlStateHighlighted];
        [self.containView addSubview:btn];
        self.emoticonBtn = btn;
        
        self.ctTop = 0;
        self.keyboardHeight = 0;
        self.ctHeight = 0;
        self.previousCtHeight = 0;
        // 键盘监听
        MM_AddObserver(self, @selector(keyboardFrameChange:), UIKeyboardWillChangeFrameNotification);
    }
    return self;
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    if (!comment) {
        self.textView.placeholderText = @"发表评论：";
    } else {
        self.textView.placeholderText = [NSString stringWithFormat:@"回复%@:",comment.fromUser.name];
    }
}

#pragma mark - 键盘监听
- (void)keyboardFrameChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = ([[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16 ) | UIViewAnimationOptionBeginFromCurrentState;
    // 键盘高度
    CGFloat keyboardH = 0;
    if (endFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) { // 弹下
        keyboardH = 0;
    } else {
        keyboardH = endFrame.size.height;
    }
    self.keyboardHeight = keyboardH;
    // 容器的top
    CGFloat top = 0;
    if (keyboardH > 0) {
        top = k_screen_height - self.containView.height - self.keyboardHeight;
    } else {
        top = k_screen_height;
    }
    self.ctTop = top;
    // 动画
    [UIView animateWithDuration:duration delay:0.0f options:options animations:^{
        self.containView.top = top;
    } completion:^(BOOL finished) {
        if (keyboardH == 0) {
            self.textView.text = nil;
            [self removeFromSuperview];
        }
    }];
    // 监听键盘高度
    if (self.MMContainerWillChangeFrameBlock) {
        self.MMContainerWillChangeFrameBlock(self.keyboardHeight);
    }
}

#pragma mark - 更新容器高度
- (void)containViewDidChange:(CGFloat)ctHeight
{
    ctHeight = ctHeight + MarginHeight;
    if (ctHeight < MMContainMinHeight || self.textView.attributedText.length == 0){
        ctHeight = MMContainMinHeight;
    }
    if (ctHeight > MMContainMaxHeight) {
        ctHeight = MMContainMaxHeight;
    }
    if (ctHeight == self.previousCtHeight) {
        return;
    }
    self.previousCtHeight = ctHeight;
    self.ctHeight = ctHeight;
    self.ctTop = k_screen_height - ctHeight - self.keyboardHeight;
    // 更新UI
    [UIView animateWithDuration:0.25 animations:^{
        // 容器
        self.containView.height = ctHeight;
        self.containView.top = self.ctTop;
        // 输入框
        self.textView.height = ctHeight - MarginHeight;
        // 表情按钮
        self.emoticonBtn.top = ctHeight - self.emoticonBtn.height;
    }];
    // 监听容器高度
    if (self.MMContainerWillChangeFrameBlock) {
        self.MMContainerWillChangeFrameBlock(self.keyboardHeight);
    }
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
    [self containViewDidChange:textView.textLayout.textBoundingSize.height];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ // 回车
        // 监听输入文本
        if (self.MMCompleteInputTextBlock) {
            self.MMCompleteInputTextBlock(textView.text);
        }
        textView.text = nil;
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    if (CGRectContainsPoint(self.containView.frame, currentPoint) == NO) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark - 显示
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.textView becomeFirstResponder];
}

#pragma mark -
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
