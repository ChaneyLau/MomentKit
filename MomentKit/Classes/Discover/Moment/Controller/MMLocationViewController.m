//
//  MMLocationViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/25.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MMLocationViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface MMLocationViewController ()<MAMapViewDelegate>

@end

@implementation MMLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"位置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)configUI
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_location.latitude, _location.longitude);
    // 地图
    CGFloat bottomHeight = 70 + k_safeArea_height;
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - bottomHeight)];
    mapView.mapType = MAMapTypeStandard;
    mapView.zoomLevel = 15;
    mapView.delegate = self;
    mapView.showsScale = YES;
    mapView.showsCompass = NO;
    mapView.showsUserLocation = NO;
    [mapView setCenterCoordinate:coordinate];
    [self.view addSubview:mapView];
    // 添加标注
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [mapView addAnnotation:annotation];
    [mapView setCenterCoordinate:coordinate];
    // 底部视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-k_top_height-bottomHeight, self.view.width, bottomHeight)];
    [self.view addSubview:bottomView];
    // 地标
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, bottomView.width - 30, 60)];
    locationLab.backgroundColor = [UIColor clearColor];
    locationLab.font = [UIFont systemFontOfSize:12.0];
    locationLab.textColor = [UIColor grayColor];
    locationLab.numberOfLines = 0;
    [bottomView addSubview:locationLab];
    // 拼接地址
    NSString *location = [NSString stringWithFormat:@"%@\n%@",_location.landmark,_location.address];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:location];
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0,[location length])];
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:18.0]
                           range:NSMakeRange(0,[_location.landmark length])];
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0,[_location.landmark length])];
    locationLab.attributedText = attributedText;
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        MAAnnotationView *annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        annotationView.image = [UIImage imageNamed:@"moment_map_point"];
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

@end
