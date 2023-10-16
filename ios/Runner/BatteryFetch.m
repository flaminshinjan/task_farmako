//
//  BatteryFetch.m
//  Runner
//
//  Created by Shinjan Patra on 15/10/23.

#import "BatteryFetch.h"
#import <UIKit/UIKit.h>

@implementation BatteryFetch

- (void)fetchBatteryLevelWithCompletion:(void (^)(float batteryLevel))completion {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;

    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        NSLog(@"Battery state is unknown.");
        completion(-1.0);  // Return -1 for unknown battery state
    }

    float batteryLevel = device.batteryLevel * 100;
    completion(batteryLevel);
}

@end
