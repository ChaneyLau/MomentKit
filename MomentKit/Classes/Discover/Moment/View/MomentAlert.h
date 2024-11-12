//
//  MomentAlert.h
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

// 点击事件block
typedef void (^MomentAlertAction)(NSInteger buttonIndex);

@interface MomentAlert : UIView

- (instancetype)initWithTitle:(NSString *)title action:(MomentAlertAction)action;

- (void)show;

@end

