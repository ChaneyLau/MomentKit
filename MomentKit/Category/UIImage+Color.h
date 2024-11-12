//
//  UIImage+Color.h
//  MomentKit
//
//  Created by LEA on 2024/10/29.
//  Copyright © 2024 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

// 颜色转图片
+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
