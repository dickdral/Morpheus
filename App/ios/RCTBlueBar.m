/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTBlueBar.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLError.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>

static int height = 10;

@interface RCTBlueBar() <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation RCTBlueBar

NSString *const RCTFrameChange = @"RCTFrameChange";

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (instancetype)init
{
  if (self = [super init]) {
    self.locationManager = [[CLLocationManager alloc] init];

    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
  }

  return self;
}

RCT_EXPORT_METHOD(start_listening_to_uuid: (NSString *) uuid_string)
{
  [self.locationManager requestWhenInUseAuthorization];

  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuid_string];
  NSLog(@"::: %@", uuid);

  CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                  initWithProximityUUID: uuid
                                  identifier: @"Hey"];

  beaconRegion.notifyOnEntry = YES;
  [self.locationManager startMonitoringForRegion:beaconRegion];
  [self.locationManager startRangingBeaconsInRegion:beaconRegion];

  NSLog(@"HEY %@", beaconRegion);
}

- (NSArray *)stringForProximity:(CLProximity)proximity {
  switch (proximity) {
    case CLProximityUnknown:    return @[@(-1), @"unknown"];
    case CLProximityFar:        return @[@(1), @"far"];
    case CLProximityNear:       return @[@(2), @"near"];
    case CLProximityImmediate:  return @[@(3), @"immediate"];
    default:
      return @[@(-1), @"unknown"];
  }
}

//
//
- (void)startObserving
{
  NSLog(@"HEY THERE %@", self.locationManager);
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(handleFrameChange:)
//                                               name:RCTFrameChange
//                                             object:nil];
//  NSDictionary<NSString *, id> *payload = @{@"height": @(RCTBlueBar.getHeight) };
//  [[NSNotificationCenter defaultCenter] postNotificationName:RCTFrameChange
//                                                      object:self
//                                                    userInfo:payload];


}
//
- (void)stopObserving
{
  NSLog(@"STOP OBSERVING");
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"beacons_did_range"];
}
//
//- (void)handleFrameChange:(NSNotification *)notification
//{
//  [self sendEventWithName:@"statusbarFrame" body:notification.userInfo];
//}
//
//+ (void)application:(UIApplication *)application
//  setStatusbar:(CGRect)statusbarFrame
//{
//  height = statusbarFrame.size.height;
//  NSDictionary<NSString *, id> *payload = @{@"height": @(RCTBlueBar.getHeight) };
//  [[NSNotificationCenter defaultCenter] postNotificationName:RCTFrameChange
//                                                      object:self
//                                                    userInfo:payload];
//}
//
//+ (int)getHeight {
//  return height;
//}

-(NSString *)nameForAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus
{
  switch (authorizationStatus) {
    case kCLAuthorizationStatusAuthorizedAlways:
      return @"authorizedAlways";

    case kCLAuthorizationStatusAuthorizedWhenInUse:
      return @"authorizedWhenInUse";

    case kCLAuthorizationStatusDenied:
      return @"denied";

    case kCLAuthorizationStatusNotDetermined:
      return @"notDetermined";

    case kCLAuthorizationStatusRestricted:
      return @"restricted";
  }
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  NSString *statusName = [self nameForAuthorizationStatus:status];
  NSLog(@"Failed ranging region: %@", statusName);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
  NSLog(@"Failed ranging region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Location manager failed: %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
  NSMutableArray *beaconArray = [[NSMutableArray alloc] init];

  
  for (CLBeacon *beacon in beacons) {
    NSLog(@"BEACON: %@", beacon);
    [beaconArray addObject:@{
                             @"uuid": [beacon.proximityUUID UUIDString],
                             @"major": beacon.major,
                             @"minor": beacon.minor,

                             @"rssi": [NSNumber numberWithLong: beacon.rssi],
                             @"proximity": [self stringForProximity: beacon.proximity],
                             @"accuracy": [NSNumber numberWithDouble: beacon.accuracy]
                             }];
  }

  NSDictionary *event = @{
                          @"region": @{
                              @"identifier": region.identifier,
                              @"uuid": [region.proximityUUID UUIDString],
                              },
                          @"beacons": beaconArray
                          };

  [self sendEventWithName:@"beacons_did_range" body:event];
}

-(void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLBeaconRegion *)region {

  NSLog(@"DID ENTER REGION: %@", region);
//  NSDictionary *event = @{
//                          @"region": region.identifier,
//                          @"uuid": [region.proximityUUID UUIDString],
//                          };
//
//  [self.bridge.eventDispatcher sendDeviceEventWithName:@"regionDidEnter" body:event];
}

-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLBeaconRegion *)region {
  NSLog(@"DID EXIT REGION: %@", region);

//  NSDictionary *event = @{
//                          @"region": region.identifier,
//                          @"uuid": [region.proximityUUID UUIDString],
//                          };
//
//  [self.bridge.eventDispatcher sendDeviceEventWithName:@"regionDidExit" body:event];
}


@end
