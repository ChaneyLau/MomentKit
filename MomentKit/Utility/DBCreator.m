//
//  DBCreator.m
//  MomentKit
//
//  Created by LEA on 2019/4/16.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "DBCreator.h"
#import "JKDBHelper.h"
#import "MomentUtil.h"

@implementation DBCreator

// 创建测试数据
+ (void)create
{
    // 将数据库写入document
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"MK" ofType:@"db"];
    NSData *dbData = [NSData dataWithContentsOfFile:dbPath];
    if (dbData) {
        NSString *docPath = [JKDBHelper dbPath];
        [dbData writeToFile:docPath atomically:YES];
    } else {
        [self createData];
    }
}

// 用于生成测试数据
+ (void)createData
{
    NSInteger count = [[MUser findAll] count];
    if (count > 0) {
        return;
    }
    // 名字
    NSArray *names = @[@"刘瑾",@"陈哲轩",@"安鑫",@"欧阳沁",@"韩艺",@"宋铭",@"童璐",@"祝子琪",@"林霜",@"赵星桐"];
    // 头像网络图片
    NSArray *images = @[@"https://img0.baidu.com/it/u=3829820236,2035194438&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400",
                        @"https://img0.baidu.com/it/u=3572579792,3752254388&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500",
                        @"https://img1.baidu.com/it/u=2582269478,2031745233&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400",
                        @"https://img2.baidu.com/it/u=2698878169,1316978882&fm=253&fmt=auto&app=138&f=JPEG?w=521&h=500",
                        @"https://img2.baidu.com/it/u=101265846,593746081&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500",
                        @"https://img2.baidu.com/it/u=4209256501,3491394904&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400",
                        @"https://img2.baidu.com/it/u=422421374,2882223448&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500",
                        @"https://img1.baidu.com/it/u=946888288,1172398339&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400",
                        @"https://img1.baidu.com/it/u=984173138,874900085&fm=253&fmt=auto&app=138&f=JPEG?w=563&h=500",
                        @"https://img1.baidu.com/it/u=3140625870,2426756945&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"];
    // 内容
    NSArray *contents = @[@"明天上午8点左右集合哈",
                          @"内娱要完啊，根本不感兴趣 😂",
                          @"知道了",
                          @"分享一个MBTI测试方法，快来测一下你的MBTI",
                          @"👌🏻",
                          @"前天给你说过了",
                          @"3号吧",
                          @"哈哈哈哈哈哈哈...",
                          @"嗯呢",
                          @"懂得都懂好吧，泰娱不要太疯啊啊啊啊啊啊啊"];
    
    // 用户 ↓↓
    NSInteger max = [names count];
    Comment *formerComment = nil; // 前一个
    for (NSInteger i = 0; i < max; i ++)
    {
        // 用户
        MUser *user = [[MUser alloc] init];
        user.type = 0;
        user.gender = arc4random() % 2;
        user.name = [names objectAtIndex:i];
        user.portrait = [images objectAtIndex:i];
        user.account = @"wxid12345678";
        user.region = @"浙江 杭州";
        [user save];
        // 消息
        Message *message = [[Message alloc] init];
        message.time = [[NSDate date] timeIntervalSince1970];
        message.userName = [names objectAtIndex:i];
        message.userPortrait = [images objectAtIndex:i];
        message.content = [contents objectAtIndex:i];
        [message save];
        // 评论
        Comment *comment = [[Comment alloc] init];
        comment.text = [contents objectAtIndex:i];
        if (i == 0) {
            comment.fromId = arc4random() % 10 + 1;
            comment.toId = 0;
        } else {
            NSInteger fromId = arc4random() % 10 + 1;
            if (fromId == formerComment.fromId) {
                comment.fromId = fromId;
                comment.toId = 0;
            } else {
                comment.fromId = fromId;
                comment.toId = formerComment.fromId;
            }
        }
        [comment save];
        formerComment = comment;
        // 图片
        MPicture *picture = [[MPicture alloc] init];
        picture.thumbnail = [images objectAtIndex:i];
        [picture save];
    }
    
    // 当前用户
    MUser *user = [[MUser alloc] init];
    user.type = 1;
    user.name = @"LEA";
    user.account = @"wxid12345678";
    user.region = @"浙江 杭州";
    user.portrait = @"https://img1.baidu.com/it/u=3068963608,3105280012&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500";
    user.momentCover = @"https://ww3.sinaimg.cn/mw690/9516662fgy1hdn77kvoe8j20j60j6mzw.jpg";
    [user save];
    
    // 位置
    MLocation *location = [[MLocation alloc] init];
    location.position = @"杭州 · 雷峰塔景区";
    location.landmark = @"雷峰塔景区";
    location.address = @"杭州市西湖区南山路15号";
    location.latitude = 30.231250;
    location.longitude = 120.148550;
    [location save];
    
    // 动态  ↓↓
    for (int i = 0; i < 35; i ++)
    {
        // 动态
        Moment *moment = [[Moment alloc] init];
        moment.userId = arc4random() % 10 + 1;
        moment.likeIds = [self getIdsByMaxPK:arc4random() % 10 + 1];
        moment.commentIds = [self getIdsByMaxPK:arc4random() % 5 + 1];
        moment.pictureIds = [self getIdsByMaxPK:arc4random() % 9 + 1];
        moment.time = 1731316800;
        moment.singleWidth = 500;
        moment.singleHeight = 302;
        moment.isLike = 0;
        if (i == 0) {
            moment.text = @"百度地址：https://www.baidu.com";
        } else if (i % 3 == 0) {
            moment.text = @"孔乙己是站着喝酒而穿长衫的唯一的人。他身材很高大；青白脸色，皱纹间时常夹些伤痕；一部乱蓬蓬的花白的胡子。穿的虽然是长衫，可是又脏又破，似乎十多年没有补，也没有洗。他对人说话，总是满口之乎者也，教人半懂不懂的。因为他姓孔，别人便从描红纸上的“上大人孔乙己”这半懂不懂的话里，替他取下一个绰号，叫作孔乙己。孔乙己一到店，所有喝酒的人便都看着他笑，有的叫道，“孔乙己，你脸上又添上新伤疤了！”他不回答，对柜里说，“温两碗酒，要一碟茴香豆。”便排出九文大钱。";
        } else if (i % 5 == 0) {
            moment.text = @"听人家背地里谈论，孔乙己原来也读过书，但终于没有进学，又不会营生；于是愈过愈穷，弄到将要讨饭了";
        } else if (i % 7 == 0) {
            moment.text = @"鲁迅老师的《孔乙己》，百科详情：https://baike.baidu.com/item/%E5%AD%94%E4%B9%99%E5%B7%B1/13826039?fr=ge_ala ";
        } else if (i % 8 == 0) {
            moment.text = @"我好饿啊，我想吃：🍔🥛🌰🍑🍟🍎🍞🍣🍟🍞🍊🍓🍉，她们让我叫外卖，☎️：18367980021。让我不要打扰她们happy，有事就发邮件：chaneyLau@126.com";
        } else {
            moment.text = @"孔乙己是这样的使人快活，可是没有他，别人也便这么过。";
        }
        [moment save];
    }
}

// 获取ids
+ (NSString *)getIdsByMaxPK:(NSInteger)maxPK
{
    NSMutableString *ids = [[NSMutableString alloc] init];
    for (int i = 1; i <= maxPK; i ++) {
        if (i == maxPK) {
            [ids appendString:[NSString stringWithFormat:@"%d",i]];
        } else {
            [ids appendString:[NSString stringWithFormat:@"%d,",i]];
        }
    }
    return ids;
}

@end
