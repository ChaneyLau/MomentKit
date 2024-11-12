//
//  MMUserDetailViewController.h
//  MomentKit
//
//  Created by LEA on 2019/4/15.
//  Copyright © 2019 LEA. All rights reserved.
//
//  用户详细资料
//

#import "UKViewController.h"
#import "MUser.h"

@interface MMUserDetailViewController : UKViewController

@property (nonatomic, strong) MUser *user;

@end

@interface MMUserDetailCell : UITableViewCell

@property (nonatomic, strong) MUser *user;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;

@end

@interface MMUserTitleCell : UITableViewCell

@property (nonatomic, strong) NSString *title;

@end

@interface MMUserActionCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;

@end
