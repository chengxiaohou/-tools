//
//  LocationManager.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/6/15.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()<CLLocationManagerDelegate>

@end

@implementation LocationManager

+ (LocationManager *)sharedManager
{
    static LocationManager *this = nil;
    // 执行一次
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      this = [[self alloc] init];
                      
                      this.locationManager = [CLLocationManager new];
                      // 代理
                      this.locationManager.delegate = this;
                      
                      
                  });
    return this;
}

- (void)updatingLocationOnceWithCallBack:(LocationReturn)callBack
{
    _locationReturnOnce = callBack;
    [self startUpdating];
}

- (void)startUpdatingLocationWithCallBack:(LocationReturn)callBack
{
    _locationReturn = callBack;
    [self startUpdating];
}

#pragma mark 开始定位
- (void)startUpdating
{
    //当定位服务开启时
    if ([CLLocationManager locationServicesEnabled])
    {
        //获取用户授权(plist写几个字)
        [_locationManager requestWhenInUseAuthorization];
        
        //定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0f; // 距离
        _locationManager.headingFilter = 10.0f;  // 方向
        
        //开始定位
        [_locationManager startUpdatingLocation];
        // 启动方向更新
        [_locationManager startUpdatingHeading];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位没开吧？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
//        // 所有回调返回nil表示位置没获取成功
//        // 持续回调
//        if (_locationReturn) {_locationReturn(nil);}
//        // 一次性回调
//        if (_locationReturnOnce)
//        {
//            _locationReturnOnce(nil);
//            _locationReturnOnce = nil;
//            [self stopUpdatingLocation];// 可能会对持续性回调造成影响，待测试
//        }
    }
}


- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}
#pragma mark - CLLocationManager收到位置更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _updateLocation = [locations firstObject];
    
    // 收到地球后立即转火星
    _updateLocation = [self transformToMars:_updateLocation];// 转
    
    // 持续回调
    if (_locationReturn) {_locationReturn(_updateLocation);}
    // 一次性回调
    if (_locationReturnOnce)
    {
        _locationReturnOnce(_updateLocation);
        _locationReturnOnce = nil;
        [self stopUpdatingLocation];// 可能会对持续性回调造成影响，待测试
    }
    
}

#pragma mark 地球转火星
- (CLLocation *)transformToMars:(CLLocation *)location {
    
    const double a = 6378245.0;
    const double ee = 0.00669342162296594323;
    
    //是否在中国大陆之外
    if ([[self class] outOfChina:location]) {
        return location;
    }
    double dLat = [[self class] transformLatWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
    double dLon = [[self class] transformLonWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
    double radLat = location.coordinate.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    return [[CLLocation alloc] initWithLatitude:location.coordinate.latitude + dLat longitude:location.coordinate.longitude + dLon];
}

+ (BOOL)outOfChina:(CLLocation *)location {
    if (location.coordinate.longitude < 72.004 || location.coordinate.longitude > 137.8347) {
        return YES;
    }
    if (location.coordinate.latitude < 0.8293 || location.coordinate.latitude > 55.8271) {
        return YES;
    }
    return NO;
}

+ (double)transformLatWithX:(double)x y:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLonWithX:(double)x y:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

@end
