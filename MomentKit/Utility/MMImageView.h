//
//  MMImageView.h
//  MomentKit
//
//  Created by LEA on 2019/4/16.
//  Copyright © 2019 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMImageView : UIImageView

@property (nonatomic, copy) void (^clickHandler)(MMImageView *imageView);

@end

