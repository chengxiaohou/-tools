//
//  LocationManager.h
//  MingPian
//
//  Created by 橙晓侯 on 2017/6/15.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"
#import <MapKit/MapKit.h>

@interface LocationManager : BaseObj 

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *updateLocation;

typedef void(^LocationReturn)(CLLocation *location);
/** 多次反复触发的回调 */
@property (strong, nonatomic) LocationReturn locationReturn;
/** 一次性的回调 */
@property (strong, nonatomic) LocationReturn locationReturnOnce;
+ (LocationManager *)sharedManager;
/** 带持续回调的定位 */
- (void)startUpdatingLocationWithCallBack:(LocationReturn)callBack;
/** 带一次性回调的定位 */
- (void)updatingLocationOnceWithCallBack:(LocationReturn)callBack;
- (void)stopUpdatingLocation;
@end
