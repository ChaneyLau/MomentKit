//
//  MessageCell.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MessageCell.h"
#import "MMImageListView.h"

@interface MessageCell ()

@property (nonatomic, strong) MMImageView *avatarImageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像
        _avatarImageV = [MMImageView new];
        _avatarImageV.layer.cornerRadius = 4.0;
        _avatarImageV.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageV];
        [_avatarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(50);
            make.centerY.equalTo(self.contentView);
        }];
        // 时间
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(_avatarImageV.mas_top);
            make.height.mas_equalTo(20);
        }];
        // 昵称
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:17.0];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageV.mas_right).offset(10);
            make.top.equalTo(_avatarImageV.mas_top).offset(2);
            make.right.equalTo(self.contentView).offset(-80);
            make.height.mas_equalTo(25);
        }];
        // 消息
        _messageLabel = [UILabel new];
        _messageLabel.font = [UIFont systemFontOfSize:13.0];
        _messageLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_messageLabel];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageV.mas_right).offset(10);
            make.top.equalTo(_nameLabel.mas_bottom);
            make.right.equalTo(self.contentView).offset(-50);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setMessage:(Message *)message
{
    if ([message.userPortrait containsString:@"http"]) {
        [self.avatarImageV sd_setImageWithURL:[NSURL URLWithString:message.userPortrait] placeholderImage:nil];
    } else {
        self.avatarImageV.image = [UIImage imageNamed:message.userPortrait];
    }
    self.nameLabel.text = message.userName;
    self.messageLabel.text = message.content;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[Utility getMessageTime:message.time]];
}

@end
